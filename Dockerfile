FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests


FROM azul/zulu-openjdk-alpine:17 AS production
WORKDIR /app
ENV SPRING_PROFILES_ACTIVE mysql, docker
RUN addgroup --system javauser && adduser -S -s /usr/sbin/nologin -G javauser javauser
ARG JAR_FILE=target/*.jar
COPY --from=build /app/${JAR_FILE} app.jar
RUN chown -R javauser:javauser .
USER javauser
ENTRYPOINT ["java", "-jar", "app.jar"]


