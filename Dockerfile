FROM gradle:7.3.3-jdk11-alpine as build

COPY --chown=gradle:gradle . /app

WORKDIR /app

RUN gradle clean --warning-mode=all

RUN gradle build -x test && rm -rf .gradle/caches/*


FROM i386/tomcat:9-jre11-slim as production

EXPOSE 8080

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]
