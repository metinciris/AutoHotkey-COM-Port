#Persistent
COMPort := "\\.\COM4" ; Doğru COM port numarasını kontrol edin.
hCOM := DllCall("CreateFile", "Str", COMPort, "UInt", 0xC0000000, "UInt", 3, "UInt", 0, "UInt", 3, "UInt", 0, "UInt", 0)

if (hCOM == -1) {
    ExitApp ; COM port bulunamazsa çıkış yap
}

; COM port ayarlarını kontrol et
DCB := VarSetCapacity(DCB, 28)
DllCall("GetCommState", "Ptr", hCOM, "Ptr", &DCB)
BaudRate := NumGet(DCB, 0, "UInt") ; Baud rate
ByteSize := NumGet(DCB, 4, "UChar") ; Byte size
Parity := NumGet(DCB, 5, "UChar") ; Parity
StopBits := NumGet(DCB, 6, "UChar") ; Stop bits

; Yanlış ayarları otomatik olarak düzelt
If (BaudRate != 9600 || ByteSize != 8 || Parity != 0 || StopBits != 1) {
    NumPut(9600, DCB, 0, "UInt") ; Baud rate 9600 olarak ayarla
    NumPut(8, DCB, 4, "UChar") ; Byte size 8
    NumPut(0, DCB, 5, "UChar") ; Parity None (0)
    NumPut(1, DCB, 6, "UChar") ; Stop bits 1
    DllCall("SetCommState", "Ptr", hCOM, "Ptr", &DCB)
}

; COM portunu okuma modunda aç
SetTimer, COMPortRead, 200 ; 200 ms aralıklarla COM portunu kontrol eder
return

COMPortRead:
    Buffer := ""
    VarSetCapacity(Buffer, 1024) ; 1024 byte'lık bir buffer oluştur
    DllCall("ReadFile", "Ptr", hCOM, "Str", Buffer, "UInt", 1024, "UInt*", BytesRead, "UInt", 0)

    ; Eğer veri varsa ve bitiş karakteri (Enter) ile sona ermişse işleme al
    if (BytesRead > 0) {
        DecodedData := StrGet(&Buffer, "UTF-8") ; UTF-8 olarak çözmeyi deneyin
        if (DecodedData == "") {
            DecodedData := StrGet(&Buffer, "CP1254") ; Eğer UTF-8 olmazsa, Türkçe karakterler için CP1254 kodlamasını deneyin
        }

        ; Eğer veri Enter (CR veya LF) karakteri ile bitmişse
        if (InStr(DecodedData, "`n") || InStr(DecodedData, "`r")) {
            ; Panoya gelen veriyi kopyala ve yapıştır
            Clipboard := DecodedData
            SendInput ^v  ; Panodaki veriyi yapıştır

            ; Enter karakterinden sonra başka veri işlenmesin, timer durduruluyor
            SetTimer, COMPortRead, Off
            return
        }
    }

    ; Buffer'ı temizle
    VarSetCapacity(Buffer, 0) ; Buffer kapasitesini sıfırla
return
