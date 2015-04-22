# xcode-translation-tool
A simple collection of scripts to support base translation processes in X-Code better

## Usage

### Create a pseudo translation 
A pseudo translation for a specific target language can be used to test if everything working without having a real translation. 
To realise this the system just adds a prefix in front of every phrase. 

```shell
xt-tool -p <<2-LETTER-TARGET-LANGUAGE-CODE
```
