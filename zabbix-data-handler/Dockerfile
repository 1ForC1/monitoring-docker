FROM golang:1.19-alpine

WORKDIR /zabbix

COPY . .

RUN go build -o zabbix main.go

RUN chmod +x zabbix

CMD ["./zabbix"]