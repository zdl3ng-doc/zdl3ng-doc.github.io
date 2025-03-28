# Spring Boot 集成 Nacos Demo

以下是一个简单的 Spring Boot 项目，展示如何使用 Nacos 进行配置管理和服务注册与发现。

## 1. 添加依赖

在 `pom.xml` 中添加以下依赖：

```xml
<dependencies>
    <!-- Spring Boot Starter -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>

    <!-- Nacos Discovery -->
    <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        <version>2021.1</version>
    </dependency>

    <!-- Nacos Config -->
    <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
        <version>2021.1</version>
    </dependency>
</dependencies>
```

## 2. 配置 Nacos

在 `application.yml` 中添加 Nacos 的配置：

```yaml
spring:
  application:
    name: nacos-demo
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
      config:
        server-addr: localhost:8848
        file-extension: yaml
```

## 3. 服务注册与发现

创建一个简单的 REST 控制器，展示服务注册与发现功能：

```java
@RestController
@RequestMapping("/demo")
public class DemoController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Nacos Demo!";
    }
}
```

## 4. 配置管理

在 Nacos 控制台中创建一个配置文件 `nacos-demo.yaml`，内容如下：

```yaml
demo:
  message: "Hello from Nacos Config!"
```

然后在代码中读取配置：

```java
@RefreshScope
@RestController
@RequestMapping("/config")
public class ConfigController {

    @Value("${demo.message}")
    private String message;

    @GetMapping("/message")
    public String getMessage() {
        return message;
    }
}
```

## 5. 启动项目

运行 Spring Boot 项目，访问以下接口：
- 服务注册与发现测试：`http://localhost:8080/demo/hello`
- 配置管理测试：`http://localhost:8080/config/message`

确保 Nacos 服务已启动，并正确配置了数据库（如 MySQL）。您可以根据需要调整配置。
