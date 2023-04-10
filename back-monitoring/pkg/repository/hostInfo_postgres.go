package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
	"github.com/lib/pq"
	"github.com/sirupsen/logrus"
)

type HostInfoPostgres struct {
	db *sql.DB
}

func NewHostInfoPostgres(db *sql.DB) *HostInfoPostgres {
	return &HostInfoPostgres{db: db}
}

func (r *HostInfoPostgres) GetHostInfo(hostid int) (model.HostInfo, error) {
	var hostInfo model.HostInfo

	query := fmt.Sprintf("SELECT * FROM %s WHERE hostid='%v'", hostInfoTable, hostid)
	row := r.db.QueryRow(query)

	if err := row.Scan(&hostInfo.IdHost, &hostInfo.HostName, pq.Array(&hostInfo.HostInterfaces), &hostInfo.ValuePerCpu1, &hostInfo.TimePerCpu1, &hostInfo.ValuePerCpu5,
		&hostInfo.TimePerCpu5, &hostInfo.ValuePerCpu15, &hostInfo.TimePerCpu15, &hostInfo.ValueSizeFree, &hostInfo.TimeSizeFree, &hostInfo.ValueSizeTotal,
		&hostInfo.TimeSizeTotal, &hostInfo.ValueMemoryAvailable, &hostInfo.TimeMemoryAvailable, &hostInfo.ValueMemoryTotal, &hostInfo.TimeMemoryTotal,
		&hostInfo.ValueCpuUtilIdle, &hostInfo.TimeCpuUtilIdle, &hostInfo.ValueCpuUtilUser, &hostInfo.TimeCpuUtilUser, &hostInfo.ValueCpuSystem,
		&hostInfo.TimeCpuSystem, &hostInfo.ValueCpuSteal, &hostInfo.TimeCpuSteal, &hostInfo.ValueCpuSoftirq, &hostInfo.TimeCpuSoftirq,
		&hostInfo.ValueCpuNice, &hostInfo.TimeCpuNice, &hostInfo.ValueCpuInterrupt, &hostInfo.TimeCpuInterrupt, &hostInfo.ValueCpuIowait, &hostInfo.TimeCpuIowait); err != nil {
		logrus.Fatal(err.Error())
	}
	if hostInfo.ValuePerCpu1.Valid == false {
		hostInfo.ValuePerCpu1.String = "н/д"
	}
	if hostInfo.TimePerCpu1.Valid == false {
		hostInfo.TimePerCpu1.String = "н/д"
	}
	if hostInfo.ValuePerCpu5.Valid == false {
		hostInfo.ValuePerCpu5.String = "н/д"
	}
	if hostInfo.TimePerCpu5.Valid == false {
		hostInfo.TimePerCpu5.String = "н/д"
	}
	if hostInfo.ValuePerCpu15.Valid == false {
		hostInfo.ValuePerCpu15.String = "н/д"
	}
	if hostInfo.TimePerCpu15.Valid == false {
		hostInfo.TimePerCpu15.String = "н/д"
	}
	if hostInfo.ValueSizeFree.Valid == false {
		hostInfo.ValueSizeFree.String = "н/д"
	}
	if hostInfo.TimeSizeFree.Valid == false {
		hostInfo.TimeSizeFree.String = "н/д"
	}
	if hostInfo.ValueSizeTotal.Valid == false {
		hostInfo.ValueSizeTotal.String = "н/д"
	}
	if hostInfo.TimeSizeTotal.Valid == false {
		hostInfo.TimeSizeTotal.String = "н/д"
	}
	if hostInfo.ValueMemoryAvailable.Valid == false {
		hostInfo.ValueMemoryAvailable.String = "н/д"
	}
	if hostInfo.TimeMemoryAvailable.Valid == false {
		hostInfo.TimeMemoryAvailable.String = "н/д"
	}
	if hostInfo.ValueMemoryTotal.Valid == false {
		hostInfo.ValueMemoryTotal.String = "н/д"
	}
	if hostInfo.TimeMemoryTotal.Valid == false {
		hostInfo.TimeMemoryTotal.String = "н/д"
	}
	if hostInfo.ValueCpuUtilIdle.Valid == false {
		hostInfo.ValueCpuUtilIdle.String = "н/д"
	}
	if hostInfo.TimeCpuUtilIdle.Valid == false {
		hostInfo.TimeCpuUtilIdle.String = "н/д"
	}
	if hostInfo.ValueCpuUtilUser.Valid == false {
		hostInfo.ValueCpuUtilUser.String = "н/д"
	}
	if hostInfo.TimeCpuUtilUser.Valid == false {
		hostInfo.TimeCpuUtilUser.String = "н/д"
	}
	if hostInfo.ValueCpuSystem.Valid == false {
		hostInfo.ValueCpuSystem.String = "н/д"
	}
	if hostInfo.TimeCpuSystem.Valid == false {
		hostInfo.TimeCpuSystem.String = "н/д"
	}
	if hostInfo.ValueCpuSteal.Valid == false {
		hostInfo.ValueCpuSteal.String = "н/д"
	}
	if hostInfo.TimeCpuSteal.Valid == false {
		hostInfo.TimeCpuSteal.String = "н/д"
	}
	if hostInfo.ValueCpuSoftirq.Valid == false {
		hostInfo.ValueCpuSoftirq.String = "н/д"
	}
	if hostInfo.TimeCpuSoftirq.Valid == false {
		hostInfo.TimeCpuSoftirq.String = "н/д"
	}
	if hostInfo.ValueCpuNice.Valid == false {
		hostInfo.ValueCpuNice.String = "н/д"
	}
	if hostInfo.TimeCpuNice.Valid == false {
		hostInfo.TimeCpuNice.String = "н/д"
	}
	if hostInfo.ValueCpuInterrupt.Valid == false {
		hostInfo.ValueCpuInterrupt.String = "н/д"
	}
	if hostInfo.TimeCpuInterrupt.Valid == false {
		hostInfo.TimeCpuInterrupt.String = "н/д"
	}
	if hostInfo.ValueCpuIowait.Valid == false {
		hostInfo.ValueCpuIowait.String = "н/д"
	}
	if hostInfo.TimeCpuIowait.Valid == false {
		hostInfo.TimeCpuIowait.String = "н/д"
	}
	return hostInfo, err
}
