#include <File.au3>
Local $app_name = "RetroPie gamelist creator"
Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
Local $ImageMagick_path = "C:\Program Files\ImageMagick-7.0.11-Q16-HDRI"

;local $download_path = "D:\dwn\atari2600out\Atari_2600"
;Local $art_path = "D:\dwn\atari2600out\Atari_2600\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\atari2600"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/atari2600"

;local $download_path = "D:\dwn\Atari_8_bit"
;Local $art_path = $download_path & "\Box"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\atari800"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/atari800"

;local $download_path = "D:\dwn\Mattel_Intellivision"
;Local $art_path = $download_path & "\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\intellivision"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/intellivision"

;local $download_path = "D:\dwn\Nintendo_Game_and_Watch"
;Local $art_path = $download_path & "\Logos"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\gameandwatch"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/gameandwatch"

;local $download_path = "D:\dwn\Atari_5200"
;Local $art_path = $download_path & "\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\atari5200"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/atari5200"

;local $download_path = "D:\dwn\Sega_SG_1000"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "sg-1000"

;local $download_path = "D:\dwn\GCE_Vectrex"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "vectrex"

;local $download_path = "D:\dwn\Nintendo_NES"
;Local $art_path = $download_path & "\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\nes"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/nes"

;local $download_path = "D:\dwn\Atari_Lynx"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "atarilynx"

;local $download_path = "D:\dwn\Daphne"
;Local $art_path = $download_path & "\Advert"
;Local $emulator_folder_name = "daphne"

;local $download_path = "D:\dwn\Amstrad_CPC"
;Local $art_path = $download_path & "\Box"
;Local $emulator_folder_name = "amstradcpc"

;local $download_path = "D:\dwn\Sega_Master_System"
;Local $mode = "Box+BoxBack"
;Local $mode = "Box_Full"
;Local $emulator_folder_name = "mastersystem"

;local $download_path = "D:\dwn\Atari_7800"
;Local $mode = "Box_Full"
;Local $emulator_folder_name = "atari7800"

;local $download_path = "D:\dwn\Sega_Genesis"
;Local $mode = "Box_Full"
;Local $emulator_folder_name = "megadrive"

;local $download_path = "D:\dwn\SNK_Neo_Geo_MVS"
;Local $mode = "Box_Full"
;Local $emulator_folder_name = "neogeo"

;local $download_path = "D:\dwn\Sega_CD"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "segacd"

;local $download_path = "D:\dwn\Nintendo_N64"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "n64"

;local $download_path = "D:\dwn\Sega_Dreamcast"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "dreamcast"

;local $download_path = "D:\dwn\SNK_Neo_Geo_Pocket_Color"
;Local $mode = "Box+BoxBack"
;Local $emulator_folder_name = "ngpc"

local $download_path = "D:\dwn\Sony_PSP"
Local $mode = "Box_Full"
Local $emulator_folder_name = "psp"






Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\" & $emulator_folder_name
Local $downloaded_images_path = "~/.emulationstation/downloaded_images/" & $emulator_folder_name
Local $art_path






; Run EmuMovies Sync and download the box art to D:\dwn
;MsgBox(0, $app_name, "Run EmuMovies Sync and download the box art to D:\dwn")



; (if "Box_Full" mode) append EmuMovies BoxBack Art to EmuMovies Box(Front) Art and output to EmuMovies Box_Full using ImageMagick

if StringCompare($mode, "Box+BoxBack") == 0 or StringCompare($mode, "Box_Full") == 0 Then

	if FileExists($download_path & "\Box_Full") = False Then

		DirCreate($download_path & "\Box_Full")
	EndIf

	Local $png_file = _FileListToArray($download_path & "\Box", "*.png")
	_ArrayDelete($png_file, 0)

	for $i = 0 to (UBound($png_file) - 1)

		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $png_file[$i] = ' & $png_file[$i] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

		_PathSplit($png_file[$i], $sDrive, $sDir, $sFileName, $sExtension)

		if FileExists($download_path & "\Box_Full\" & $png_file[$i]) = False And FileExists($download_path & "\Box_Full\" & $sFileName & ".jpg") = False And FileExists($download_path & "\BoxBack\" & $png_file[$i]) = True Then

			ShellExecuteWait("magick.exe", """" & $download_path & "\BoxBack\" & $png_file[$i] & """ """ & $download_path & "\Box\" & $png_file[$i] & """ +append """ & $download_path & "\Box_Full\" & $png_file[$i] & """", $ImageMagick_path, "", @SW_HIDE)
		EndIf
	Next
EndIf


if StringCompare($mode, "Box+BoxBack") == 0 Or StringCompare($mode, "Box_Full") == 0 Then

	$art_path = $download_path & "\Box_Full"
EndIf


; Convert all art from PNG to JPG (to reduce filesize) at 80% quality using ImageMagick

if FileExists($art_path) = True Then

	Local $png_file = _FileListToArray($art_path, "*.png")
	_ArrayDelete($png_file, 0)

	for $i = 0 to (UBound($png_file) - 1)

		_PathSplit($png_file[$i], $sDrive, $sDir, $sFileName, $sExtension)

		if FileExists($art_path & "\" & $sFileName & ".jpg") = False Then

			ShellExecuteWait("magick.exe", "-quality 80% """ & $art_path & "\" & $png_file[$i] & """ """ & $art_path & "\" & $sFileName & ".jpg""", $ImageMagick_path, "", @SW_HIDE)
		EndIf
	Next
EndIf


; Remove all PNG files (leaving only the JPG versions)

Local $png_file = _FileListToArray($art_path, "*.png")
_ArrayDelete($png_file, 0)

if UBound($png_file) > 0 Then

	for $i = 0 to (UBound($png_file) - 1)

		_PathSplit($png_file[$i], $sDrive, $sDir, $sFileName, $sExtension)

		if FileExists($art_path & "\" & $sFileName & ".jpg") = False then

			ConsoleWrite("Could not find the JPG for " & $png_file[$i] & ".  stopping.")
			Exit
		Else

			; Remove the PNG file

			FileDelete($art_path & "\" & $png_file[$i])
		EndIf
	Next
EndIf

; Create gamelist.xml


Local $arr = _FileListToArray($rom_path)
_ArrayDelete($arr, 0)

Local $xml = ""
$xml = $xml & "<?xml version=""1.0""?>" & @CRLF
$xml = $xml & "<gameList>" & @CRLF

for $i = 0 to (UBound($arr) - 1)

	_PathSplit($arr[$i], $sDrive, $sDir, $sFileName, $sExtension)

	if StringCompare($sExtension, ".state") <> 0 Then

;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $arr[$i] = ' & $arr[$i] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

		$xml = $xml & "	<game>" & @CRLF
		$xml = $xml & "		<path>./" & $sFileName & $sExtension & "</path>" & @CRLF
		$xml = $xml & "		<name>" & $sFileName & "</name>" & @CRLF

		if FileExists($art_path & "\" & $sFileName & ".jpg") = True Then

			$xml = $xml & "		<image>" & $downloaded_images_path & "/" & $sFileName & ".jpg</image>" & @CRLF
		EndIf

		$xml = $xml & "	</game>" & @CRLF

	EndIf
Next

$xml = $xml & "</gameList>" & @CRLF

if FileExists($download_path & "\gamelist.xml") = True Then

	FileDelete($download_path & "\gamelist.xml")
EndIf

FileWrite($download_path & "\gamelist.xml", $xml)

ConsoleWrite("Manually copy " & $art_path & "\*.jpg to /opt/retropie/configs/all/emulationstation/downloaded_images/" & $emulator_folder_name & @CRLF)
ConsoleWrite("Manually copy " & $download_path & "\gamelist.xml to /opt/retropie/configs/all/emulationstation/gamelists/" & $emulator_folder_name & @CRLF)


