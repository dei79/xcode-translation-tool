# xcode-translation-tool
A simple collection of scripts to support base translation processes in X-Code better

## Usage

### Create a pseudo translation 
A pseudo translation for a specific target language can be used to test if everything working without having a real translation. 
To realise this the system just adds a prefix in front of every phrase. 

```shell
xt-tool -p <<2-LETTER-TARGET-LANGUAGE-CODE
```

### Ignore specific files
Normally the tool is using every strings and storyboard file in every run. Ignoring specific sub folders or files is possible with just created a .xctignore file which contains a list of path or folder patterns which needs to be ignored. The following example is a usual one:

```
Pods
vendor
external
```
