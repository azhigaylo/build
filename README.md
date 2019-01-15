
### HomeBrain project description:

програмный комплекс, построенный на базе ОС Линукс, позволяющий превратить ноутбук или мини компьютер (BeagleBoard)
в централезованную систему сбора данных c модулей ввода/вывода по протоколу ModBus RTU и передачу конечному потребителю по протоколу MQTT.

### Project includes follow components:

1. Buil         - набор скриптов для билда проекта под Linux Host и под Linux Target
                   * Linux Host сборка удобна для отладки проекта и дальнейшего перехода на таргет.
                     её результатом является набор бинарников которые могут запускаться по Linux Ubuntu and similar.
                   * Linux Target сборка базируется на BuildRoot пакете, её результатом является образ файловой системы 
                     в формате ext2/ext4, готовый для распаковки на одноплатном мини компьютере.
2. HomeBrain    - основной процесс опрашивающий I/O модули по протоколу ModBus RTU.
                  считывает регистры ModBus и сохраняяет данные в внутреннюю таблицу точек(дискретные, аналоговые)
3. mqttgtw      - процесс который занимается преобразованием данных с таблицы точек HomeBrain
                  в значения MQTT топиков.
4. pointmonitor - тул, позволяющий просматривать текущее состояние точек(дискретные, аналоговые) HomeBrain
                  не является необходимым для работы комплекса, и нужен только на этапе отладки системы.
5. csvparser    - парсер *.csv документа, в котором описывается конфигурация mqttgtw


### Supported system :

*   Host: Ubuntu Linux 18.04 
*   Target: BeagleBone Black 

### Schematic project map:

---picture---


### Installation for development:

### For possible contributors:

Pull requests are welcome.
If you would like to make changes/fix, please follow these rules:

1. The pull requests accepted only in "development" barnch
2. All changes/fixes should be tested before commit


### an example of implemented system that are based on HomeBrain complex

## License
[MIT](https://choosealicense.com/licenses/mit/)