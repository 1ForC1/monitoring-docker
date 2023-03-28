package model

type Host struct {
	IdHost         int      `json:"id_host" db:"hostid"`
	HostName       string   `json:"host_name" db:"name_host"`
	HostInterfaces []string `json:"host_interfaces" db:"ip_host"`
}

var host []Host
