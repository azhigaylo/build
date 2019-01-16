
### HomeBrain project description:

OS Linux based software package, which allows turn your laptop or mini computer (BeagleBoard) into a centralized 
data acquisition system from I/O modules by ModBus RTU protocol, and transfer data to the user via frandly MQTT protocol.

### Project includes follow components:

1. Build        - a set of scripts for project build under Linux Host and Linux Target
                   * Linux Host build is convenient for debugging the project and further transition to the target.
                     as result you will have set of binaries, which can be started on Linux Ubuntu and similar.
                   * Linux Target build based on BuildRoot package, result is an image of the file system
                     in ext2/ext4 format, which are ready for extractiin on SD card to use in miniPC (BeagleBone)
2. HomeBrain    - the main process, which communicate with I/O modules via ModBus RTU protocol.
                  reads ModBus registers and saves data in the internal table of points (discrete, analog)
3. mqttgtw      - the process that converts data from the HomeBrain point table to MQTT topic values.
4. pointmonitor - This tools allows you to view the current state of the HomeBrain points (discrete, analog). 
                  It is not necessary for the system operation, and is needed only on debugging stage.
5. csvparser    - parser *.csv documents, which describes the configuration for mqttgtw.


### Supported system :

*   Host: Ubuntu Linux 18.04 
*   Target: BeagleBone Black 

### Schematic project map:

---picture---


### Installation for development:

1. First step it's HOST preparetion. Needed to setup some development and thirdparty. There two variant of preparation:

     - prepare HOST for host build
     
```bash
./prepare_all.sh -i
```

    - prepare HOST for target build

```bash
./prepare_all.sh -it
```
      difference is only one things, for target build BuildRoot will be uploaded and builded.

      for help :
```bash
./prepare_all.sh --help
```

2. Second step it's build all project.There two variant of build:

    - build for HOST
    
```bash
./build_all.sh
```
     result will be available in folder <homebrain_products>

    - build for TARGET
    
```bash
./build_all.sh -t
```

    result will be available in folder </homebrain_third_party/host/buildroot/output/images/>

    for help :
```bash
./build_all.sh --help
```

### For possible contributors:

Pull requests are welcome.
If you would like to make changes/fix, please follow these rules:

1. The pull requests accepted only in "development" barnch
2. All changes/fixes should be tested before commit


### an example of implemented system that are based on HomeBrain complex

## License
[MIT](https://choosealicense.com/licenses/mit/)