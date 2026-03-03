# Consignes du rapport - Livrable etudiant

Le livrable attendu est un document Word presentant la realisation du projet Agent IA Marketing Local. Les elements suivants doivent etre inclus de maniere obligatoire.

---

## 1. Captures d'ecran obligatoires

### 1.1 Interface n8n fonctionnelle

- Capture d'ecran de l'ensemble du workflow importe et configure dans n8n (tous les noeuds visibles)
- Capture d'ecran du panneau de chat avec une requete envoyee et la reponse de l'agent affichee
- Capture d'ecran du detail du noeud AI Agent montrant le prompt systeme et la connexion aux outils

### 1.2 Configuration du modele dans Ollama

- Capture d'ecran de la liste des modeles installes (commande `ollama list` dans un terminal, ou interface Ollama)
- Capture d'ecran ou mention du modele utilise (TinyLlama recommande, ou Llama 3, Mistral) avec indication de la version

### 1.3 Resultat de l'execution

- Capture d'ecran du resultat obtenu lors d'un test avec une URL reelle (exemple : analyse d'un site web et generation de strategie de contenu)
- La requete testee et la reponse complete de l'agent doivent etre visibles

---

## 2. Tests de prompt

Inclure au moins deux tests avec des requetes differentes :

- Un test avec une URL de site web (le site doit etre specifie)
- Un test avec une variante (par exemple : demande de strategie pour un secteur specifique, ou question de suivi)

Pour chaque test : recopier la requete, la reponse de l'agent, et une breve analyse (pertinence, coherence, utilisation ou non de l'outil de recuperation web).

---

## 3. Analyse des logs

- Decrire comment acceder aux logs d'execution dans n8n (onglet Executions)
- Inclure une capture d'ecran d'une execution reussie montrant : le declencheur, les noeuds executes, le statut (succes/erreur)
- En cas d'utilisation de l'outil HTTP Request : montrer dans les logs que l'agent a bien appele l'outil et recu des donnees

---

## 4. Structure recommandee du document Word

1. Page de garde (nom, prenom, formation, date)
2. Introduction (objectif du projet en une demi-page)
3. Configuration technique (Docker, Ollama, n8n) avec captures d'ecran
4. Presentation du workflow et des noeuds (avec capture du workflow complet)
5. Tests de prompt et resultats
6. Analyse des logs
7. Conclusion (difficultes rencontrees, points d'amelioration)
8. Annexes (captures complementaires si necessaire)

---

## 5. Criteres d'evaluation

- Completude : toutes les captures demandees sont presentes
- Fonctionnement : l'agent repond correctement et utilise l'outil de recuperation web quand une URL est fournie
- Qualite de l'analyse : les tests et l'analyse des logs temoignent d'une comprehension du fonctionnement agentique
- Presentation : document structure, lisible, sans faute d'orthographe majeure

---

## 6. Format de remise

- Document unique au format .docx
- Nom du fichier : Nom_Prenom_AgentIA_Marketing_M1.docx
- Remise selon les modalites indiquees par l'enseignant (plateforme, date limite)

---

## 7. Checklist de verification avant remise

Cocher avant d'envoyer le rapport :

- [ ] **1.1** Capture workflow complet n8n ; capture panneau chat (requete + reponse) ; capture detail noeud AI Agent (prompt systeme + outils)
- [ ] **1.2** Capture liste des modeles (`ollama list` ou interface Ollama) ; modele utilise et version indiques
- [ ] **1.3** Capture resultat test avec URL reelle ; requete et reponse completes visibles
- [ ] **2** Au moins 2 tests : un avec URL (site precise), un variante ; pour chaque : requete, reponse, breve analyse (pertinence, coherence, utilisation outil web)
- [ ] **3** Texte expliquant l'acces aux logs (onglet Executions) ; capture execution reussie (declencheur, noeuds, statut) ; si HTTP Request : preuve dans les logs de l'appel et des donnees recues
- [ ] **4** Structure du document respectee (page de garde, intro, config, workflow, tests, logs, conclusion, annexes)
- [ ] **6** Fichier .docx nomme Nom_Prenom_AgentIA_Marketing_M1.docx
