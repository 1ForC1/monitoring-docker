package configHelper

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"zabbix-data-handler/errorHelper"
	"zabbix-data-handler/structs"
)

// GetConfig Получение конфига
func GetConfig() {
	var err error
	if _, err = os.Stat("./cfg.json"); os.IsNotExist(err) {
		//Создание файла конфига
		fmt.Printf("Создание файла конфигурации...")

		configInfo, err := json.MarshalIndent(structs.Config, "", "\t")
		errorHelper.PrintError(err)
		err = ioutil.WriteFile("./cfg.json", configInfo, 0644)
		errorHelper.PrintError(err)
	}
	//Загрузка файлов конфигурации
	fmt.Printf("Загрузка файла конфигурации...")

	configInfo, err := ioutil.ReadFile("./cfg.json")
	errorHelper.PrintError(err)
	err = json.Unmarshal(configInfo, &structs.Config)
	errorHelper.PrintError(err)
}
