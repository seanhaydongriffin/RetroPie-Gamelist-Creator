#include <File.au3>
Local $app_name = "RetroPie gamelist creator"
Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""


;local $gamelist_path = "D:\dwn\atari2600out\Atari_2600"
;Local $art_path = "D:\dwn\atari2600out\Atari_2600\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\atari2600"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/atari2600"

;local $gamelist_path = "D:\dwn\Atari_8_bit"
;Local $art_path = $gamelist_path & "\Box"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\atari800"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/atari800"

;local $gamelist_path = "D:\dwn\Mattel_Intellivision"
;Local $art_path = $gamelist_path & "\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\intellivision"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/intellivision"

;local $gamelist_path = "D:\dwn\Nintendo_Game_and_Watch"
;Local $art_path = $gamelist_path & "\Logos"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\gameandwatch"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/gameandwatch"

;local $gamelist_path = "D:\dwn\Atari_5200"
;Local $art_path = $gamelist_path & "\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\atari5200"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/atari5200"

;local $gamelist_path = "D:\dwn\Sega_SG_1000"
;Local $art_path = $gamelist_path & "\Box"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\sg-1000"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/sg-1000"

;local $gamelist_path = "D:\dwn\Nintendo_NES"
;Local $art_path = $gamelist_path & "\Box_Full"
;Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\nes"
;Local $downloaded_images_path = "~/.emulationstation/downloaded_images/nes"

local $gamelist_path = "D:\dwn\Atari_Lynx"
Local $art_path = $gamelist_path & "\Box"
Local $emulator_folder_name = "atarilynx"






Local $rom_path = "F:\RetroPie\home\pi\RetroPie\roms\" & $emulator_folder_name
Local $downloaded_images_path = "~/.emulationstation/downloaded_images/" & $emulator_folder_name

; Run EmuMovies Sync and download the box art to D:\dwn
;MsgBox(0, $app_name, "Run EmuMovies Sync and download the box art to D:\dwn")

; Convert all (PNG) files to JPG using Faststone Image Viewer ...

ShellExecute("FSViewer.exe", "-i """ & $art_path & """", "C:\Program Files (x86)\FastStone Image Viewer")

WinWait("[CLASS:FastStoneImageViewerMainForm.UnicodeClass]")
SendKeepActive("[CLASS:FastStoneImageViewerMainForm.UnicodeClass]")
send("{CTRLDOWN}a{CTRLUP}")
Sleep(500)
send("{F3}")

WinWait("[TITLE:Batch Image Convert / Rename; CLASS:TBatchConvert]")
SendKeepActive("[TITLE:Batch Image Convert / Rename; CLASS:TBatchConvert]")
Sleep(5000)
ControlCommand("[TITLE:Batch Image Convert / Rename; CLASS:TBatchConvert]", "", "[CLASS:TCheckBox; INSTANCE:2]", "UnCheck")
ControlClick("[TITLE:Batch Image Convert / Rename; CLASS:TBatchConvert]", "", "[TEXT:Convert]")

WinWait("[TITLE:Image Convert; CLASS:TBatchConvertDialog]")
SendKeepActive("[TITLE:Image Convert; CLASS:TBatchConvertDialog]")

While True

	ControlGetHandle("[TITLE:Image Convert; CLASS:TBatchConvertDialog]", "", "[TEXT:Done]")

	if @error = 0 Then

		ExitLoop
	EndIf

	sleep(500)
WEnd

WinClose("[TITLE:Image Convert; CLASS:TBatchConvertDialog]")
WinClose("[CLASS:FastStoneImageViewerMainForm.UnicodeClass]")


; Check all JPG files exist, and if not exit

Local $png_file = _FileListToArray($art_path, "*.png")
_ArrayDelete($png_file, 0)

if UBound($png_file) > 0 Then

	Local $jpg_file = _FileListToArray($art_path, "*.jpg")
	_ArrayDelete($jpg_file, 0)

	for $i = 0 to (UBound($png_file) - 1)

		_PathSplit($png_file[$i], $sDrive, $sDir, $sFileName, $sExtension)

		Local $result = _ArraySearch($jpg_file, $sFileName & ".jpg")

		if $result < 0 Then

			ConsoleWrite("Could not find the JPG for " & $png_file[$i] & ".  stopping.")
			Exit
		EndIf
	Next

	; Remove all PNG files

	FileDelete($art_path & "\*.png")
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

		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $arr[$i] = ' & $arr[$i] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;		if FileExists($art_path & "\" & $sFileName & ".jpg") = True Then

			$xml = $xml & "	<game>" & @CRLF
			$xml = $xml & "		<path>./" & $sFileName & $sExtension & "</path>" & @CRLF
			$xml = $xml & "		<name>" & $sFileName & "</name>" & @CRLF

			if FileExists($art_path & "\" & $sFileName & ".jpg") = True Then

				$xml = $xml & "		<image>" & $downloaded_images_path & "/" & $sFileName & ".jpg</image>" & @CRLF
			EndIf

			$xml = $xml & "	</game>" & @CRLF
;		EndIf

	EndIf
Next

$xml = $xml & "</gameList>" & @CRLF

if FileExists($gamelist_path & "\gamelist.xml") = True Then

	FileDelete($gamelist_path & "\gamelist.xml")
EndIf

FileWrite($gamelist_path & "\gamelist.xml", $xml)

ConsoleWrite("Manually copy " & $art_path & "\*.jpg to /opt/retropie/configs/all/emulationstation/downloaded_images/" & $emulator_folder_name & @CRLF)
ConsoleWrite("Manually copy " & $gamelist_path & "\gamelist.xml to /opt/retropie/configs/all/emulationstation/gamelists/" & $emulator_folder_name & @CRLF)


