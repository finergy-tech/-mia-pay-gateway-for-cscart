# Modul MIA POS pentru CS-Cart

Integrați sistemul de plată **MIA POS** în magazinul dumneavoastră CS-Cart pentru a accepta plăți online prin coduri QR și cereri directe de plată (RTP).

## Descriere

MIA POS, furnizat de Finergy Tech, permite procesarea sigură a plăților folosind coduri QR și Request to Pay. Modulul suportă actualizarea automată a statutului comenzilor și mai multe limbi.

### Funcționalități
- Acceptați plăți prin coduri QR.
- Suport pentru plăți Request to Pay (RTP).
- Actualizare automată a statutului comenzilor.
- Procesare sigură a plăților folosind semnătura.
- Suport multilingv: RO, RU, EN.

## Cerințe
- Cont MIA POS de la Finergy Tech.
- CS-Cart versiunea **4.7.2+**.
- PHP 7.2 sau o versiune mai nouă.
- Extensii PHP activate: **curl**, **json**.
- Certificat SSL activ pentru tranzacții sigure.

## Instalare
1. Descărcați arhiva modulului MIA POS.
2. În panoul de administrare CS-Cart, accesați **Add-ons** > **Manage add-ons**.
3. Încărcați și instalați modulul MIA POS folosind butonul **Upload & Install**.
4. După instalare, accesați **Administrare** > **Metode de plată** și apăsați „+” pentru a adăuga o nouă metodă.
5. În lista **Processor**, selectați **MIA POS**.
6. Configurați setările necesare în fila **Configure** și salvați.

## Setări
1. **Merchant ID**: Identificatorul unic MIA POS.
2. **Terminal ID**: Oferit de MIA POS în timpul înregistrării.
3. **Cheie secretă**: Cheie pentru autentificarea API.
4. **URL API**: Endpoint pentru comunicarea cu API-ul MIA POS.
5. **Statuturi ale comenzilor**:
    - **Plata în așteptare**: Statut pentru plățile în așteptare.
    - **Plata reușită**: Statut pentru plățile finalizate cu succes.
    - **Plata eșuată**: Statut pentru plățile nereușite.
6. **Limbă**: Selectați limba preferată pentru pagina de plată (RO, RU, EN).

## Testare
1. Utilizați mediul de test MIA POS și datele de test furnizate de Finergy Tech.
2. Simulați plăți și verificați actualizarea statutului comenzilor.
3. Verificați notificările callback pentru plăți reușite și eșuate.

## Suport
Pentru asistență, contactați:
- Website: [https://finergy.md/](https://finergy.md/)
- Email: [info@finergy.md](mailto:info@finergy.md)
