# Stage 1: Build the Spring Boot application
FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Create the Docker image
FROM azul/zulu-openjdk-alpine:17 AS production
WORKDIR /app
RUN addgroup --system javauser && adduser -S -s /usr/sbin/nologin -G javauser javauser
ARG JAR_FILE=target/*.jar
COPY --from=build /app/${JAR_FILE} app.jar
RUN chown -R javauser:javauser .
USER javauser
ENTRYPOINT ["java", "-jar", "app.jar"]