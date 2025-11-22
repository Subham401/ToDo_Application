# ---------- Build stage ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copy Maven wrapper + config
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Make wrapper executable and build JAR
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# ---------- Run stage ----------
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy the built jar from the build stage (version-agnostic)
COPY --from=build /app/target/*SNAPSHOT.jar app.jar
# or if you prefer: COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
