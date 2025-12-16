-- SHAMS IMMO - Création du premier administrateur
--
-- INSTRUCTIONS :
-- 1. Créez d'abord un utilisateur dans Supabase Authentication :
--    - Allez dans votre projet Supabase > Authentication > Users
--    - Cliquez sur "Add user"
--    - Email: admin@shamsimmo.com (ou votre email)
--    - Password: votre_mot_de_passe_sécurisé
--    - Cliquez sur "Create user"
--
-- 2. Copiez l'ID de l'utilisateur créé (visible dans la colonne ID)
--
-- 3. Exécutez la requête ci-dessous en remplaçant 'VOTRE_ID_UTILISATEUR'
--    par l'ID copié à l'étape 2

INSERT INTO collaborators (
  id,
  first_name,
  last_name,
  email,
  phone,
  role
)
VALUES (
  'VOTRE_ID_UTILISATEUR',  -- Remplacez par l'ID de l'utilisateur Supabase
  'Admin',                  -- Prénom
  'SHAMS IMMO',            -- Nom
  'admin@shamsimmo.com',   -- Email (doit correspondre à celui de Supabase)
  '+212600000000',         -- Téléphone
  'admin'                  -- Rôle (ne pas modifier)
);

-- Après avoir exécuté cette requête, vous pourrez vous connecter
-- au dashboard avec l'email et le mot de passe configurés dans Supabase Auth
