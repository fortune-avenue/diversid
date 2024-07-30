import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/constants/themes/themes.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/services.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  TTSService get ttsService => ref.read(ttsServiceProvider);

  @override
  void initState() {
    ttsService.speak('Halaman Daftar');
    super.initState();
  }

  bool _isChecked = false;

  void onChanged(bool? value) {
    setState(() {
      if (value != null) _isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    HiveService hiveService = ref.read(hiveServiceProvider);
    hiveService.isFirstInstall = true;

    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: CustomScrollWidget(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: ExcludeSemantics(
                child: Assets.images.elipse.image(
                  height: context.screenHeightPercentage(0.4),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                child: PaddingWidget(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Assets.svgs.logoPrimary.svg(
                          semanticsLabel: "DiversID Logo",
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorApp.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: ColorApp.shadow,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeApp.w16,
                          vertical: SizeApp.h32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Daftar',
                              style: TypographyApp.headline3.black,
                            ),
                            Gap.h16,
                            InputFormWidget(
                              controller: TextEditingController(),
                              hintText: 'Nama Lengkap',
                            ),
                            Gap.h16,
                            InputFormWidget(
                              controller: TextEditingController(),
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Email',
                            ),
                            Gap.h16,
                            InputFormWidget.password(
                              controller: TextEditingController(),
                              hintText: 'Kata Sandi',
                            ),
                            Gap.h12,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: onChanged,
                                ),
                                Gap.w8,
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsAndConditionsPage())),
                                    child: Text(
                                      'Saya setuju dengan Syarat & Ketentuan',
                                      style: TypographyApp.text2.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap.h12,
                            ButtonWidget.primary(
                              text: 'Daftar',
                              onTap: () {},
                            ),
                            Gap.h12,
                            ButtonWidget.outlined(
                              text: 'Masuk',
                              semanticsLabel: 'Tekan untuk Masuk',
                              onTap: () {
                                context.goNamed(
                                  Routes.login.name,
                                  pathParameters: {'fromDeeplink': 'none'},
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: ExcludeSemantics(
              child: Assets.images.elipse.image(
                height: context.screenHeightPercentage(0.4),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: PaddingWidget(
                child: Column(
                  children: [
                    Gap.h16,
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: SizeApp.h48,
                          width: SizeApp.h48,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              CupertinoIcons.chevron_back,
                              semanticLabel: 'Kembali',
                              color: ColorApp.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          '''Syarat dan Ketentuan DiversID

1. Pendahuluan
Selamat datang di DiversID! Dengan membuat akun dan menggunakan layanan kami, Anda menyetujui Syarat dan Ketentuan (S&K) berikut. Harap baca dengan seksama.

2. Penerimaan Persyaratan
Dengan mendaftar akun di DiversID, Anda mengakui bahwa Anda telah membaca, memahami, dan setuju untuk terikat oleh S&K ini. Jika Anda tidak setuju, mohon untuk tidak menggunakan layanan kami.

3. Kelayakan Pengguna
Untuk menggunakan layanan kami, Anda harus berusia minimal 18 tahun atau memiliki kapasitas hukum untuk membuat kontrak yang mengikat berdasarkan hukum yang berlaku.

4. Pendaftaran Akun
- Akurasi Informasi: Anda setuju untuk memberikan informasi yang akurat dan lengkap selama proses pendaftaran dan selalu memperbarui informasi akun Anda.
- Keamanan Akun: Anda bertanggung jawab untuk menjaga kerahasiaan detail login akun Anda dan untuk semua aktivitas yang terjadi di bawah akun Anda. Segera beri tahu kami jika ada penggunaan yang tidak sah atas akun Anda.

5. Perilaku Pengguna
- Kepatuhan terhadap Hukum: Anda setuju untuk menggunakan layanan DiversID dengan mematuhi semua hukum dan peraturan yang berlaku.
- Aktivitas yang Dilarang: Anda setuju untuk tidak menggunakan layanan kami untuk tujuan yang melanggar hukum atau tidak sah, termasuk namun tidak terbatas pada penipuan, pencucian uang, atau aktivitas apapun yang dapat merugikan DiversID atau penggunanya.

6. Kebijakan Privasi
Kebijakan Privasi kami (tautan ke Kebijakan Privasi) menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda. Dengan menggunakan layanan kami, Anda menyetujui pengumpulan dan penggunaan informasi seperti yang dijelaskan dalam Kebijakan Privasi kami. Privasi dan keamanan data Anda adalah prioritas utama kami, dan kami mematuhi semua undang-undang dan peraturan perlindungan data yang relevan.

7. Persetujuan untuk Komunikasi Elektronik
Dengan membuat akun, Anda menyetujui untuk menerima komunikasi elektronik dari DiversID, termasuk tetapi tidak terbatas pada email, SMS, dan pemberitahuan. Anda dapat memilih untuk tidak menerima komunikasi tertentu, tetapi beberapa pesan penting diperlukan untuk manajemen akun.

8. Layanan Keuangan
- Kepatuhan: DiversID mematuhi semua peraturan yang relevan, termasuk persyaratan anti pencucian uang (AML) dan mengenal nasabah (KYC).
- Proses E-KYC: Anda setuju untuk memberikan dokumen dan informasi identifikasi yang akurat selama proses E-KYC. DiversID menggunakan alat berbasis AI untuk verifikasi guna memastikan identitas Anda dan meningkatkan keamanan.

9. Privasi dan Keamanan Data
- Pengumpulan Data: Kami mengumpulkan informasi pribadi yang diperlukan untuk penyediaan layanan kami, termasuk dokumen identifikasi dan detail kontak.
- Penggunaan Data: Data Anda hanya digunakan untuk tujuan verifikasi identitas, kepatuhan terhadap kewajiban hukum, dan peningkatan layanan.
- Pembagian Data: Kami tidak membagikan informasi pribadi Anda kepada pihak ketiga kecuali sebagaimana diwajibkan oleh hukum atau dengan persetujuan eksplisit dari Anda.
- Perlindungan Data: Kami menerapkan langkah-langkah keamanan yang kuat untuk melindungi data Anda dari akses yang tidak sah, perubahan, pengungkapan, atau penghancuran.

10. Batasan Tanggung Jawab
DiversID tidak bertanggung jawab atas kerusakan langsung, tidak langsung, insidental, atau konsekuensial yang timbul dari penggunaan Anda atas layanan kami. Kami tidak menjamin akses yang terus menerus, tanpa gangguan, atau aman ke layanan kami.

11. Modifikasi terhadap Ketentuan
DiversID berhak untuk mengubah S&K ini kapan saja. Kami akan memberi tahu Anda tentang perubahan yang signifikan, dan penggunaan Anda yang berkelanjutan atas layanan kami merupakan penerimaan dari persyaratan yang dimodifikasi.

12. Pengakhiran
DiversID berhak untuk menangguhkan atau menghentikan akun Anda setiap saat dengan alasan apapun, termasuk namun tidak terbatas pada pelanggaran S&K atau aktivitas yang mencurigakan.

13. Hukum yang Mengatur
S&K ini diatur dan ditafsirkan sesuai dengan hukum yang berlaku di Indonesia. Setiap perselisihan yang timbul dari S&K ini akan tunduk pada yurisdiksi eksklusif pengadilan di Indonesia.

14. Informasi Kontak
Untuk pertanyaan atau masalah apa pun terkait S&K ini, silakan hubungi kami di support@diversid.com.''',
                          style: TypographyApp.text1.black,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Gap.h24,
                    ButtonWidget.primary(
                      text: 'Kembali',
                      onTap: () {
                        context.pop();
                      },
                    ),
                    Gap.h20,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
