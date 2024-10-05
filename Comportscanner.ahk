#Persistent
COMPort := "\\.\COM4" ; Doğru COM port numarasını kontrol edin.
hCOM := DllCall("CreateFile", "Str", COMPort, "UInt", 0xC0000000, "UInt", 3, "UInt", 0, "UInt", 3, "UInt", 0, "UInt", 0)

if (hCOM == -1) {
    MsgBox, COM Port Bulunamadı: %COMPort%
    ExitApp
}

; Baud rate ve diğer ayarları yapılandır
DCB := Chr(26) . Chr(0) . Chr(0) . Chr(0) . Chr(0) . Chr(0) . Chr(0) . Chr(0)
DllCall("SetCommState", "Ptr", hCOM, "Ptr", &DCB)

; COM portunu sadece veri geldiğinde işle
SetTimer, COMPortRead, 200 ; 200 ms aralıklarla COM portunu kontrol eder
return

COMPortRead:
    Buffer := ""
    VarSetCapacity(Buffer, 1024) ; 1024 byte'lık bir buffer oluştur
    DllCall("ReadFile", "Ptr", hCOM, "Str", Buffer, "UInt", 1024, "UInt*", BytesRead, "UInt", 0)

    ; Eğer veri varsa, bunu ASCII ya da UTF-8 olarak çözümle
    if (BytesRead > 0) {
        ; Gelen veriyi uygun kodlama ile çözümlüyoruz
        DecodedData := StrGet(&Buffer, "UTF-8") ; UTF-8 olarak çözmeyi deneyin
        if (DecodedData == "") {
            DecodedData := StrGet(&Buffer, "CP1254") ; Eğer UTF-8 olmazsa, Türkçe karakterler için CP1254 kodlamasını deneyin
        }

        ; Panoya gelen veriyi kopyala
        Clipboard := DecodedData

        ; Aktif pencereye veriyi yaz
        SendInput %DecodedData%  ; Barkod verisini aktif pencereye yaz

        ; Enter tuşunu manuel olarak gönder
        SendInput {Enter}
    }
return
