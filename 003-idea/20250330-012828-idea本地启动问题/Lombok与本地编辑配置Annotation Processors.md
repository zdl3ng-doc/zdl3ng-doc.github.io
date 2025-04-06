# Lombok @Data 没有生成 Getter/Setter 方法的解决方案

## ✨ 问题描述
在使用 Lombok 时，通常 `@Data` 注解会自动生成 `get/set` 方法。但在 IDEA 中，我们遇到了一个奇怪的问题：

- 代码里 **明明已经加了 `@Data`**，但编译后却 **没有生成 `get/set` 方法**。
- IDEA 启动项目时出现 Lombok 相关警告：
  
  ```
  java: You aren't using a compiler supported by lombok, so lombok will not work and has been disabled.
    Your processor is: com.sun.proxy.$Proxy8
    Lombok supports: sun/apple javac 1.6, ECJ
  ```
- 依赖分析 (`mvn dependency:tree`) 发现 Lombok 存在 **多个不同版本**。
- **`mvn install` 能正常编译，但 IDEA 启动时报错，而用 `jar` 包启动却正常**。

最终发现，**Lombok 版本冲突** 以及 **IDEA 的 Annotation Processor 处理异常** 是主要原因。

---

## 🛠️ 问题原因分析

### ✨ 1. Lombok 版本冲突
通过 IDEA 的 **Maven 依赖树** 查看 Lombok 版本，发现有 **多个 Lombok 版本**：

```plaintext
org.projectlombok:lombok:1.18.8 (compile) (omitted for conflict with: 1.18.22)
org.projectlombok:lombok:1.18.22 (compile)
```

可能的影响：
- IDEA 可能 **错误地选择了 Lombok 处理器**，导致 `@Data` 失效。
- **不同版本 Lombok 可能不兼容**，导致 `annotationProcessor` 解析失败。
- 低版本 Lombok 可能 **没有正确生成方法**。

### ✨ 2. IDEA 启动机制导致 Annotation Processor 失效

在 `mvn install` 正常、`jar` 包启动正常的情况下，**但 IDEA 直接运行时失败**，说明问题出在 **IDEA 的项目编译和运行机制**。

#### **IDEA 启动时干了什么？**
1. IDEA **不会直接使用 Maven 的 `compile` 结果**，而是采用 **自己的编译器**（Javac 或 ECJ）。
2. 在编译时，**会调用 Annotation Processor**（如 Lombok、MapStruct）。
3. **如果 IDEA 没有正确识别 `Processor path`，Annotation Processor 可能不会运行**。
4. **最终，Lombok 没有生成 `get/set` 方法，导致运行时报错**。

#### **Processor path 机制**
Processor path 是 IDEA 用于查找 **Annotation Processor 位置** 的路径，主要涉及：
- **IDEA 设置的 Annotation Processor**（`Settings > Build, Execution, Deployment > Compiler > Annotation Processors`）。
- **Maven `annotationProcessorPaths` 配置**（如果项目手动指定了 `annotationProcessorPaths`，IDEA 可能不会正确使用）。
- **IDEA 自己的编译流程**（IDEA 可能会忽略 `mvn install` 产生的结果，而直接用 `target/classes` 进行运行）。

如果 IDEA **找不到 Lombok 处理器**，则 `@Data` 失效，导致 `get/set` 方法缺失。

---

## 🛠️ 解决方案

### **✅ 1. 统一 Lombok 版本**
**在 `pom.xml` 里保留最新版本**，确保只使用 **1.18.22**：

```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.22</version>
    <scope>provided</scope>
</dependency>
```

然后 **删除旧版本 Lombok**，运行：

```sh
mvn dependency:tree
```

确保只剩下 `1.18.22`。

---

### **✅ 2. 让 IDEA 重新识别 Lombok 的 Annotation Processor**

#### **🔍 方法 1：手动调整 IDEA 设置**

1. 打开 `File > Settings > Build, Execution, Deployment > Compiler > Annotation Processors`
2. **选择** `Obtain processors from project classpath`
3. **取消勾选** `Processor path`
4. 点击 `Apply` 并 `OK`
5. **重启 IDEA**

#### **🔍 方法 2：删除 `.idea/` 目录，重新导入 Maven**

```sh
rm -rf .idea/
mvn clean
mvn idea:clean idea:idea
```

然后重新启动 IDEA，并 **重新导入 `pom.xml`**。

---

### **✅ 3. 重新编译**

最后，重新编译项目：

```sh
mvn clean compile
```

这会让 Lombok 的 `annotationProcessor` **重新执行**，确保 `get/set` 方法正确生成。

---

## 🔮 总结
✅ **Lombok 版本冲突** 导致 `Processor path` 识别异常，让 `@Data` 失效。
✅ **只保留 `1.18.22`，删除其他 Lombok 版本**。
✅ **确保 IDEA Annotation Processor 设置正确，启用 Lombok 处理器**。
✅ **删除 `.idea/` 重新导入项目，强制 IDEA 重新识别 Lombok**。
✅ **IDEA 启动方式不同于 `mvn install`，需要检查 `Processor path` 机制**。
✅ **重新编译项目，确认 `get/set` 方法生成**。

如果你也遇到这个问题，按照这篇文章的方法操作，应该就能解决了！

---

### **✈ 参考**
- [Lombok 官方文档](https://projectlombok.org/)
- [Maven 依赖管理](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)
- [IDEA Annotation Processor 配置](https://www.jetbrains.com/help/idea/annotation-processors-support.html)

---

