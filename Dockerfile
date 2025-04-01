FROM openjdk:21

WORKDIR /app

COPY build/libs/*.jar serviceDiscovery.jar

CMD ["java", "-jar", "serviceDiscovery.jar"]