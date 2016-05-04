FLEX_HOME="/Applications/Adobe Flash Builder 4.7/sdks/4.6.0"
FLEX_BIN_FOLDER="${FLEX_HOME}/bin"

GOOGLE_PLAY_SERVICES_LIB="./google-play-services_lib"

BIN_FOLDER="./bin"
TEMP_FOLDER="./temp"

EXT_JAR_NAME="TapjoyGPSAIRExtension"
EXT_ANE_NAME="google-play-services"
EXT_SWC_NAME="google-play-services"

AS_EXT_FOLDER="./extension/as3/src/com/tapjoy/android/gps"

JAVA_EXT_ROOT_FOLDER="./extension/java"
JAVA_EXT_SRC_FOLDER="$JAVA_EXT_ROOT_FOLDER/src/com/tapjoy/android/gps"
JAVA_EXT_BIN_FOLDER="$JAVA_EXT_ROOT_FOLDER/bin"

FLASH_RUNTIME_EXTENSIONS="./libs/FlashRuntimeExtensions.jar"

ANDROID_PLATFORM_CONFIG="./configs/android_options.xml"
EXTENSION_CONFIG="./configs/extension.xml"

# Input folders containing native libraries and assets to be compiled into the ANE
COMPILATION_FOLDER_ANDROID="$TEMP_FOLDER/bin/android/release"
COMPILATION_FOLDER_DEFAULT="$TEMP_FOLDER/bin/default/release"

clean() {
	echo =================================
	echo Cleaning folders
	echo =================================
	rm -rf "$TEMP_FOLDER"

	rm -rf "$BIN_FOLDER"
	rm -fr "$JAVA_EXT_BIN_FOLDER"

	mkdir "$BIN_FOLDER"

	mkdir -p "$JAVA_EXT_BIN_FOLDER"/classes
	mkdir -p "$JAVA_EXT_BIN_FOLDER"/jar

	mkdir -p "$COMPILATION_FOLDER_ANDROID"
	mkdir -p "$COMPILATION_FOLDER_DEFAULT"
}

jar_google_play_air_code() {
	echo
	echo =================================
	echo Compiling the Java AIR Extension
	echo =================================
	
	# Find all .java files in the extension folder
	find $JAVA_EXT_ROOT_FOLDER -name "*.java" > ./temp/javaSources.txt

	# Compile .java into classes
	javac -d "$JAVA_EXT_BIN_FOLDER"/classes @./temp/javaSources.txt -classpath "$FLASH_RUNTIME_EXTENSIONS"

	echo
	echo =================================
	echo Creating Google Play Services AIR Extension jar
	echo =================================
	jar cfv "$EXT_JAR_NAME.jar" -C "$JAVA_EXT_BIN_FOLDER/classes" .
	mv "$EXT_JAR_NAME.jar" "$JAVA_EXT_BIN_FOLDER/jar"

	echo
	echo =================================
	echo Copying "$EXT_JAR_NAME".jar to bin folders
	echo =================================
	cp "$JAVA_EXT_BIN_FOLDER/jar/$EXT_JAR_NAME.jar" "$COMPILATION_FOLDER_ANDROID"
}

build_compalation_folder() {
	echo
	echo =================================
	echo Copying Google Play Services to bin folders
	echo =================================
	cp "$GOOGLE_PLAY_SERVICES_LIB"/libs/google-play-services.jar "$COMPILATION_FOLDER_ANDROID"	

	cp -R "$GOOGLE_PLAY_SERVICES_LIB"/res "$COMPILATION_FOLDER_ANDROID"/google-play-services-res

	echo
	echo =================================
	echo Building the $EXT_SWC_NAME ActionScript SWC
	echo =================================

	"$FLEX_BIN_FOLDER"/compc -output "$EXT_SWC_NAME.swc" \
	-load-config "$FLEX_HOME"/frameworks/airmobile-config.xml \
	-include-sources "$AS_EXT_FOLDER"/* --

	echo
	echo =================================
	echo Unziping the library.swf to the bin folders
	echo =================================
	unzip -o "$EXT_SWC_NAME.swc" library.swf -d "$COMPILATION_FOLDER_ANDROID"
	unzip -o "$EXT_SWC_NAME.swc" library.swf -d "$COMPILATION_FOLDER_DEFAULT"

	mv "$EXT_SWC_NAME.swc" "$BIN_FOLDER/$EXT_SWC_NAME.swc"
}

build_ane() {
	echo
	echo =================================
	echo Building GooglePlayServices ANE
	echo =================================

	"$FLEX_BIN_FOLDER"/adt -package -target ane "$EXT_ANE_NAME.ane" $EXTENSION_CONFIG -swc "$BIN_FOLDER/$EXT_SWC_NAME.swc" \
	-platform "Android-ARM" -platformoptions $ANDROID_PLATFORM_CONFIG -C "$COMPILATION_FOLDER_ANDROID""/" -C "$COMPILATION_FOLDER_ANDROID" . \
	-platform "default" -C "$COMPILATION_FOLDER_DEFAULT" .

	mv $EXT_ANE_NAME.ane "$BIN_FOLDER/$EXT_ANE_NAME.ane"

	echo
	echo =================================
	echo Build finished
	echo =================================
	echo $EXT_ANE_NAME.ane and $EXT_SWC_NAME.swc outputed to $BIN_FOLDER
	echo
}

############################################
# MAIN
############################################
clear

# exit on error
set -e

clean
jar_google_play_air_code
build_compalation_folder
build_ane