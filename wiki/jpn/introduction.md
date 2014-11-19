=================
Introduction
=================
[English](../eng/01.introduction.rst)


はじめに
-------------

「Noue」はPython用のC言語エミュレーターです。  
C言語ソースコードをPythonコードに変換して実行します。  
C言語ソースのユニットテストを、Python上で行うためのツールとして  
開発しています。  




test.c  
```c

    #include<stdio.h>
    
    void hello()
    {
        printf("HelloWorld\n");
    }
```

test.py:  
```python

    from noue.compiler import CCompiler
    
    test = CCompiler().compile('test.c')
    
    import ctypes
    test.printf = ctypes.cdll.msvcrt.printf
    
    test.times()
```
	
	
出力:  
```console
    >HelloWorld
```

C言語ソースをピュアPythonコードに変換して実行するので  
Pythonの標準ライブラリであるpdbが使用できます。  


