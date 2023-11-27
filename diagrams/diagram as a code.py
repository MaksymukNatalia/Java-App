from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.database import MongoDB
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.network import Tomcat
from diagrams.onprem.iac import Ansible
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import Jenkins
from diagrams.programming.language import Java

with Diagram("Schedule Web Service", ):
    with Cluster("server manager"):
        tom = Tomcat("Tomcat9")
        with Cluster("Schedule app"):
            srv = Server("class_schedule.war")

    Edge(color="red", style="dashed") \
    << Redis("Redis") \
    << Edge(label="cache") \
    << srv

    Edge(color="brown", style="dashed") \
    << PostgreSQL("PostgreSQL") \
    << Edge(label="collect data") \
    << srv

    Edge(color="brown", style="dashed") \
    - MongoDB("MongoDB") \
    << Edge(label="archiving") \
    << srv
