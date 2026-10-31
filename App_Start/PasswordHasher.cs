using System;
using System.Security.Cryptography;

namespace StudySphere.Security
{
    public static class PasswordHasher
    {
        private const int Iterations = 150000;
        private const int SaltSize = 16;
        private const int HashSize = 32;
        private const string Prefix = "PBKDF2$";

        public static string Hash(string password)
        {
            byte[] salt = new byte[SaltSize];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
                rng.GetBytes(salt);

            using (var derive = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
                return Prefix + Iterations + "$" + Convert.ToBase64String(salt) + "$" +
                    Convert.ToBase64String(derive.GetBytes(HashSize));
        }

        public static bool IsHashed(string value)
        {
            return value != null && value.StartsWith(Prefix, StringComparison.Ordinal);
        }

        public static bool Verify(string password, string stored)
        {
            if (!IsHashed(stored)) return false;
            string[] parts = stored.Split('$');
            int iterations;
            if (parts.Length != 4 || !int.TryParse(parts[1], out iterations) || iterations < 1)
                return false;
            try
            {
                byte[] salt = Convert.FromBase64String(parts[2]);
                byte[] expected = Convert.FromBase64String(parts[3]);
                using (var derive = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
                    return FixedTimeEquals(expected, derive.GetBytes(expected.Length));
            }
            catch (FormatException) { return false; }
        }

        public static bool FixedTimeEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length) return false;
            int diff = 0;
            for (int i = 0; i < a.Length; i++) diff |= a[i] ^ b[i];
            return diff == 0;
        }
    }
}
