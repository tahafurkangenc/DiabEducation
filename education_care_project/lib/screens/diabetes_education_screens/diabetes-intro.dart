import 'package:flutter/material.dart';
import '/services/api_service.dart';

class diabetes_introScreen extends StatefulWidget {
  @override
  _DiabetesIntroScreenState createState() => _DiabetesIntroScreenState();
}

class _DiabetesIntroScreenState extends State<diabetes_introScreen> {
  bool _isLoading = false;

  Future<void> _sendHalfProgress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.updateProgress(
        'Diyabet Eğitimi',        // Kategori
        'diyabet_basics',         // Modül Adı
        false,                    // Tamamlandı mı?
        50,                       // İlerleme Yüzdesi
        'HbA1c Testinin Önemi',   // Konu Başlığı
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme %50 olarak güncellendi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme güncellenirken bir hata oluştu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendCompletion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.updateProgress(
        'Diyabet Eğitimi',        // Kategori
        'diyabet_basics',         // Modül Adı
        true,                     // Tamamlandı mı?
        100,                      // İlerleme Yüzdesi
        'HbA1c Testinin Önemi',   // Konu Başlığı
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modül tamamlandı olarak güncellendi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Güncellerken bir hata oluştu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyabet Eğitimi'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // İlk Metin Bölümü
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
**HbA1c Testinin Önemi**

HbA1c testi, kan şekeri kontrolünün uzun vadeli bir göstergesi olduğu için diyabet yönetiminde kritik bir araçtır. HbA1c seviyeleri, hem diyabet tanısı koymak hem de hastalığın ne kadar iyi kontrol edildiğini izlemek için kullanılır.

**Normal HbA1c Seviyeleri:**
- Sağlıklı bireylerde: %4 - %5,6
- Prediyabet (diyabet riski): %5,7 - %6,4
- Diyabet: %6,5 ve üzeri

**HbA1c Sonuçlarının Yorumlanması**
- **Düşük HbA1c Seviyeleri:** Kan şekeri seviyelerinin iyi kontrol edildiğini gösterir. Ancak aşırı düşük seviyeler hipoglisemi riskini artırabilir.
- **Yüksek HbA1c Seviyeleri:** Diyabetin kontrol edilmediğini veya kan şekeri seviyelerinin sık sık yüksek olduğunu gösterir. Bu durum, diyabetle ilişkili komplikasyon riskini artırır.
''',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),

            // İlerlemeyi Yarıya Kadar Güncelle Butonu
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendHalfProgress,
              child: Text('İlerlemeyi Yarıya Kadar Güncelle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
                minimumSize: Size(double.infinity, 50), // Buton genişliğini arttırmak için
              ),
            ),
            SizedBox(height: 20),

            // İkinci Metin Bölümü
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
**Diyabet ve HbA1c Testinin Önemi**

HbA1c testi, diyabetli bireylerin sağlıklı bir yaşam sürdürmeleri için düzenli olarak yapılması gereken bir testtir. Aşağıdaki nedenlerle önemlidir:

- **Uzun Vadeli Takip:** Kan şekeri kontrolünün ne kadar iyi yapıldığını gösterir.
- **Komplikasyon Riskini Azaltma:** Yüksek HbA1c seviyeleri, kalp hastalıkları, böbrek sorunları, nöropati ve görme kaybı gibi komplikasyon riskini artırır.
- **Tedavi Planlaması:** Doktorlar, HbA1c sonuçlarına göre tedavi planlarını güncelleyebilir ve kişiselleştirilmiş önerilerde bulunabilir.

**Diyabet Yönetiminde HbA1c Nasıl Düşürülür?**
- **Sağlıklı Beslenme:** Karbonhidrat alımını kontrol etmek, düşük glisemik indeksli besinler tüketmek ve dengeli bir diyet uygulamak önemlidir.
- **Fiziksel Aktivite:** Düzenli egzersiz, insülin duyarlılığını artırır ve kan şekeri seviyelerini düşürmeye yardımcı olur.
- **İlaçlar ve İnsülin:** Doktorun önerdiği şekilde ilaç veya insülin kullanmak gereklidir.
- **Stres Yönetimi:** Stres, kan şekeri seviyelerini etkileyebilir. Meditasyon, yoga veya benzeri yöntemler yararlı olabilir.
- **Düzenli Takip:** Kan şekeri ölçümlerini ve HbA1c testlerini düzenli olarak yaptırmak önemlidir.

**Sonuç**
Diyabet, düzenli takip ve sağlıklı yaşam tarzı değişiklikleri ile kontrol edilebilecek bir hastalıktır. HbA1c testi, diyabetin teşhisi ve yönetimi için vazgeçilmez bir araçtır. Sağlıklı bir yaşam sürdürmek için doktorun önerilerine uymak ve HbA1c seviyelerini kontrol altında tutmak büyük önem taşır.

Eğer diyabetiniz varsa veya risk altında olduğunuzu düşünüyorsanız, bir sağlık uzmanına danışarak HbA1c testi yaptırmanız sağlığınız için en iyi adım olacaktır.
''',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Modülü Tamamla Butonu
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendCompletion,
              child: Text('Modülü Tamamla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
                minimumSize: Size(double.infinity, 50), // Buton genişliğini arttırmak için
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
