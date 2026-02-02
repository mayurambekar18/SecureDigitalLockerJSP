package com.locker.util;

import java.security.MessageDigest;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class CryptoUtil {

    // ===================== VERNAM SETTINGS (Technique) =====================
    private static final String VERNAM_KEY = "Vernam@Key";
    private static final String KEY_16 = "Mayu@LockerKey16";

    // Masked AES key stored as Base64 (generated using Vernam XOR)
    private static final String AES_KEY_MASKED_B64 = vernamEncryptBase64(KEY_16, VERNAM_KEY);

    // Get real AES key back (unmask)
    private static String getAesKey() {
        String realKey = vernamDecryptBase64(AES_KEY_MASKED_B64, VERNAM_KEY);

        // ✅ Proof in GlassFish Output (optional)
        System.out.println("VERNAM: AES key masked(Base64) = " + AES_KEY_MASKED_B64);
        System.out.println("VERNAM: AES key unmasked length = " + realKey.length());

        return realKey; // must be 16 chars
    }

    // ===================== SHA-256 (Algorithm) =====================
    public static String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // ===================== AES (Algorithm) =====================
    private static SecretKeySpec aesKey() {
        try {
            return new SecretKeySpec(getAesKey().getBytes("UTF-8"), "AES");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String aesEncrypt(String plainText) {
        try {
            Cipher c = Cipher.getInstance("AES");
            c.init(Cipher.ENCRYPT_MODE, aesKey());
            return Base64.getEncoder().encodeToString(c.doFinal(plainText.getBytes("UTF-8")));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String aesDecrypt(String cipherText) {
        try {
            Cipher c = Cipher.getInstance("AES");
            c.init(Cipher.DECRYPT_MODE, aesKey());
            byte[] dec = Base64.getDecoder().decode(cipherText);
            return new String(c.doFinal(dec), "UTF-8");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // ===================== VIGENERE (Technique) =====================
    public static String vigenereEncrypt(String text, String key) {
        if (text == null) return "";
        text = text.toUpperCase();
        key = key.toUpperCase();

        StringBuilder out = new StringBuilder();
        int j = 0;

        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c >= 'A' && c <= 'Z') {
                int shift = key.charAt(j % key.length()) - 'A';
                char enc = (char) ('A' + (c - 'A' + shift) % 26);
                out.append(enc);
                j++;
            } else {
                out.append(c);
            }
        }
        return out.toString();
    }

    public static String vigenereDecrypt(String text, String key) {
        if (text == null) return "";
        text = text.toUpperCase();
        key = key.toUpperCase();

        StringBuilder out = new StringBuilder();
        int j = 0;

        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c >= 'A' && c <= 'Z') {
                int shift = key.charAt(j % key.length()) - 'A';
                char dec = (char) ('A' + (c - 'A' - shift + 26) % 26);
                out.append(dec);
                j++;
            } else {
                out.append(c);
            }
        }
        return out.toString();
    }

    // ===================== VERNAM (Technique) =====================
    // XOR + Base64
    public static String vernamEncryptBase64(String plain, String key) {
        try {
            byte[] p = plain.getBytes("UTF-8");
            byte[] k = key.getBytes("UTF-8");
            byte[] out = new byte[p.length];

            for (int i = 0; i < p.length; i++) {
                out[i] = (byte) (p[i] ^ k[i % k.length]);
            }
            return Base64.getEncoder().encodeToString(out);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String vernamDecryptBase64(String cipherB64, String key) {
        try {
            byte[] c = Base64.getDecoder().decode(cipherB64);
            byte[] k = key.getBytes("UTF-8");
            byte[] out = new byte[c.length];

            for (int i = 0; i < c.length; i++) {
                out[i] = (byte) (c[i] ^ k[i % k.length]);
            }
            return new String(out, "UTF-8");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
