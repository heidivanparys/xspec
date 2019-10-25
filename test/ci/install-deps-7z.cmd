echo on

rem root dir
if not defined XSPEC_DEPS set "XSPEC_DEPS=%TEMP%\xspec"

rem expecting curl and 7z to be available

rem set curl
set CURL=curl
set "CURL=%CURL% -fsSL --create-dirs --retry 5"

rem install Saxon
set "SAXON_JAR=%XSPEC_DEPS%\saxon\saxon9he.jar"
%CURL% -o "%SAXON_JAR%" "http://central.maven.org/maven2/net/sf/saxon/Saxon-HE/%SAXON_VERSION%/Saxon-HE-%SAXON_VERSION%.jar"

rem install XML Calabash
if not defined XMLCALABASH_VERSION (
    echo XML Calabash will not be installed
) else (
    %CURL% -o "%XSPEC_DEPS%\xmlcalabash\xmlcalabash.zip" "https://github.com/ndw/xmlcalabash1/releases/download/%XMLCALABASH_VERSION%/xmlcalabash-%XMLCALABASH_VERSION%.zip"
    7z -y x "%XSPEC_DEPS%\xmlcalabash\xmlcalabash.zip" -o"%XSPEC_DEPS%\xmlcalabash"
    set "XMLCALABASH_JAR=%XSPEC_DEPS%\xmlcalabash\xmlcalabash-%XMLCALABASH_VERSION%\xmlcalabash-%XMLCALABASH_VERSION%.jar"
)

rem install BaseX
if not defined BASEX_VERSION (
    echo BaseX will not be installed
) else (
    %CURL% -o "%XSPEC_DEPS%\basex\basex.zip" "http://files.basex.org/releases/%BASEX_VERSION%/BaseX%BASEX_VERSION:.=%.zip"
    7z -y x "%XSPEC_DEPS%\basex\basex.zip" -o"%XSPEC_DEPS%\basex"
    set "BASEX_JAR=%XSPEC_DEPS%\basex\basex\BaseX.jar"
)

rem install Ant without installing JDK
rem call "%~dp0choco-install.cmd" ant --allow-downgrade --ignore-dependencies --no-progress --version "%ANT_VERSION%"
%CURL% -o "%TEMP%\xspec\ant\ant.tar.gz" "http://archive.apache.org/dist/ant/binaries/apache-ant-%ANT_VERSION%-bin.tar.gz"
7z -y x "%TEMP%\xspec\ant\ant.tar.gz" -o"%TEMP%\xspec\ant"
7z -y x "%TEMP%\xspec\ant\ant.tar" -o"%TEMP%\xspec\ant"
set "ANT_HOME=%TEMP%\xspec\ant\apache-ant-%ANT_VERSION%"
if not exist "%ANT_HOME%" (
    rem Create dir to invalidate any preinstalled Ant
    mkdir "%ANT_HOME%"
)
path %ANT_HOME%\bin;%PATH%

rem install XML Resolver
set "XML_RESOLVER_JAR=%XSPEC_DEPS%\xml-resolver\resolver.jar"
%CURL% -o "%XML_RESOLVER_JAR%" "http://central.maven.org/maven2/xml-resolver/xml-resolver/1.2/xml-resolver-1.2.jar"

rem install Jing
if not defined JING_VERSION (
    echo Jing will not be installed
) else (
    set "JING_JAR=%XSPEC_DEPS%\jing\jing.jar"
)
if defined JING_JAR %CURL% -o "%JING_JAR%" "http://central.maven.org/maven2/org/relaxng/jing/%JING_VERSION%/jing-%JING_VERSION%.jar"

rem clean up
set CURL=
