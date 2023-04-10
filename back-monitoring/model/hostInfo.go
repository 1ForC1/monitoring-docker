package model

import "database/sql"

type HostInfo struct {
	IdHost               int            `json:"id_host" db:"hostid"`
	HostName             string         `json:"host_name" db:"name_host"`
	HostInterfaces       []string       `json:"host_interfaces" db:"ip_host"`
	ValuePerCpu1         sql.NullString `json:"value_percpu_avg1" db:"value_percpu_avg1"`
	TimePerCpu1          sql.NullString `json:"time_percpu_avg1" db:"time_percpu_avg1"`
	ValuePerCpu5         sql.NullString `json:"value_percpu_avg5" db:"value_percpu_avg5"`
	TimePerCpu5          sql.NullString `json:"time_percpu_avg5" db:"time_percpu_avg5"`
	ValuePerCpu15        sql.NullString `json:"value_percpu_avg15" db:"value_percpu_avg15"`
	TimePerCpu15         sql.NullString `json:"time_percpu_avg15" db:"time_percpu_avg15"`
	ValueSizeFree        sql.NullString `json:"value_size_free" db:"value_size_free"`
	TimeSizeFree         sql.NullString `json:"time_size_free" db:"time_size_free"`
	ValueSizeTotal       sql.NullString `json:"value_size_total" db:"value_size_total"`
	TimeSizeTotal        sql.NullString `json:"time_size_total" db:"time_size_total"`
	ValueMemoryAvailable sql.NullString `json:"value_memory_available" db:"value_memory_available"`
	TimeMemoryAvailable  sql.NullString `json:"time_memory_available" db:"time_memory_available"`
	ValueMemoryTotal     sql.NullString `json:"value_memory_total" db:"value_memory_total"`
	TimeMemoryTotal      sql.NullString `json:"time_memory_total" db:"time_memory_total"`
	ValueCpuUtilIdle     sql.NullString `json:"value_cpu_util_idle" db:"value_cpu_util_idle"`
	TimeCpuUtilIdle      sql.NullString `json:"time_cpu_util_idle" db:"time_cpu_util_idle"`
	ValueCpuUtilUser     sql.NullString `json:"value_cpu_util_user" db:"value_cpu_util_user"`
	TimeCpuUtilUser      sql.NullString `json:"time_cpu_util_user" db:"time_cpu_util_user"`
	ValueCpuSystem       sql.NullString `json:"value_cpu_system" db:"value_cpu_system"`
	TimeCpuSystem        sql.NullString `json:"time_cpu_system" db:"time_cpu_system"`
	ValueCpuSteal        sql.NullString `json:"value_cpu_steal" db:"value_cpu_steal"`
	TimeCpuSteal         sql.NullString `json:"time_cpu_steal" db:"time_cpu_steal"`
	ValueCpuSoftirq      sql.NullString `json:"value_cpu_softirq" db:"value_cpu_softirq"`
	TimeCpuSoftirq       sql.NullString `json:"time_cpu_softirq" db:"time_cpu_softirq"`
	ValueCpuNice         sql.NullString `json:"value_cpu_nice" db:"value_cpu_nice"`
	TimeCpuNice          sql.NullString `json:"time_cpu_nice" db:"time_cpu_nice"`
	ValueCpuInterrupt    sql.NullString `json:"value_cpu_interrupt" db:"value_cpu_interrupt"`
	TimeCpuInterrupt     sql.NullString `json:"time_cpu_interrupt" db:"time_cpu_interrupt"`
	ValueCpuIowait       sql.NullString `json:"value_cpu_iowait" db:"value_cpu_Iowait"`
	TimeCpuIowait        sql.NullString `json:"time_cpu_iowait" db:"time_cpu_Iowait"`
}
