
### Build scripts for HomeBrain project.

Build scripts a set of scripts for project build under Linux Host and Linux Target

- **Linux Host build** is usefull for debugging the project and further transition to the target. As result you will have set of binaries, which can be started on Linux Ubuntu and similar.

- **Linux Target build** based on BuildRoot package, result is an image of the file system in ext2/ext4 format, which are ready for extracting on SD card to use in miniPC (BeagleBone)

### Supported system :

*   Host: Ubuntu Linux 18.04 
*   Target: BeagleBone Black 

###### How to, in steps :
- **First step** it's HOST preparetion. Needed to setup some development and thirdparty. There two variant of preparation:

   - prepare HOST for host build     
```bash
           ./prepare_all.sh -i
```

   - prepare HOST for target build
```bash
           ./prepare_all.sh -it
```

   - help :
```bash
           ./prepare_all.sh --help
```

- **Second step** it's build all project.There two variant of build:

   - build for HOST, result will be available in folder <homebrain_products>
```bash
           ./build_all.sh
```

   - build for TARGET, result will be available in folder </homebrain_third_party/host/buildroot/output/images/>
```bash
           ./build_all.sh -t
```
   - help :
```bash
           ./build_all.sh --help
```

### For possible contributors:

Pull requests are welcome.
If you would like to make changes/fix, please follow these rules:

1. The pull requests accepted only in "development" barnch
2. All changes/fixes should be tested before commit

## License
[MIT](https://choosealicense.com/licenses/mit/)
