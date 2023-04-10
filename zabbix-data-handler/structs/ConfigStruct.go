package structs

// ConfigStruct Структура конфигурации
type ConfigStruct struct {
	LoginZabbix    string
	PasswordZabbix string
	Time           string
	Url            string
	HostDB         string
	PortDB         int
	UserDB         string
	PasswordDB     string
	DBName         string
	LoginServer    string
	PasswordServer string
	DoDeleteFrom   bool
}

// Config Данные по умолчанию
var Config = ConfigStruct{"Admin",
	"zabbix",
	"00h01m00s",
	"http://192.168.42.200/zabbix/api_jsonrpc.php",
	"127.0.0.1",
	5432,
	"postgres",
	"12345678",
	"zabbix_api",
	"user",
	"12345678",
	true}
