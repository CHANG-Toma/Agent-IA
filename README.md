# Agent-IA-Marketing-Local-M1

## Introduction

### Objectifs pedagogiques

Ce projet vise a permettre aux etudiants de Master 1 de concevoir et deployer un Agent IA autonome sur leur machine personnelle, sans aucun cout d'infrastructure (100% gratuit). Les objectifs pedagogiques sont les suivants :

- Comprendre la difference entre un workflow traditionnel lineaire et un workflow agentique
- Maitriser l'architecture technique d'un systeme d'IA locale (conteneurisation, orchestration, moteur LLM)
- Configurer et connecter les composants (Docker, n8n, Ollama) pour faire fonctionner un agent
- Implementer un cas d'usage concret en marketing : analyse d'URL web et generation de strategie de contenu

Le livrable attendu est un document Word (.docx) respectant les consignes detaillees : captures d'ecran (workflow n8n, panneau chat, noeud AI Agent, configuration Ollama, resultat d'execution), au moins deux tests de prompt avec analyse, analyse des logs d'execution (onglet Executions), et la structure recommandee (page de garde, introduction, configuration, workflow, tests, logs, conclusion). Nom du fichier : `Nom_Prenom_AgentIA_Marketing_M1.docx`. **Consignes completes :** [04-Livrable/consignes-rapport.md](04-Livrable/consignes-rapport.md)

---

## Theorie : Definition d'un Agent IA

### Qu'est-ce qu'un Agent IA ?

Un Agent IA est un systeme logiciel capable d'effectuer des taches de maniere autonome en interagissant avec un environnement. Contrairement aux modeles de langage classiques qui repondent de maniere statique a une requete, un agent possede trois caracteristiques fondamentales :

1. **L'autonomie** : L'agent decide lui-meme quelles actions entreprendre. Par exemple, face a une question sur un site web, il choisit d'utiliser l'outil de recherche web pour recuperer des informations plutot que de repondre directement a partir de son propre parametrage. Cette decision repose sur une evaluation de la requete et des ressources disponibles.

2. **La boucle de reflexion** : L'agent analyse les resultats de ses actions, evalue si l'objectif est atteint, et decide s'il doit poursuivre (par exemple en appelant un autre outil) ou fournir une reponse finale a l'utilisateur.

3. **Les outils** : Un agent dispose d'un ensemble d'outils (tools) qu'il peut invoquer : recherche web, lecture de fichiers, appel d'API, calculs, etc. L'orchestrateur (n8n) gere l'appel de ces outils selon les instructions du modele.

### Workflow lineaire vs workflow agentique

| Critere | Workflow lineaire | Workflow agentique |
|---------|-------------------|-------------------|
| Parcours | Sequence fixe et predeterminee d'etapes | Parcours dynamique selon les besoins |
| Decision | L'utilisateur ou le developpeur definit a l'avance le flux | L'agent decide quels outils appeler et dans quel ordre |
| Adaptabilite | Faible : une requete inattendue peut bloquer le flux | Elevee : l'agent s'adapte au contexte |
| Exemple | Formulaire -> Extraction -> Envoi email | Requete -> Analyse -> Choix outil (recherche/fichier/API) -> Reponse |

Le workflow agentique repose sur un cycle : reception de la requete, reflexion du modele, selection d'un outil (ou reponse finale), execution, re-integration du resultat dans le contexte, puis reprise du cycle jusqu'a satisfaction.

### Concepts cles a retenir

**L'autonomie** : L'agent choisit lui-meme d'utiliser l'outil de recherche web (ou de recuperation d'URL) plutot que de repondre directement car il n'a pas acces au contenu des pages sans cet outil. Il evalue la requete, identifie le besoin d'informations externes, et decide d'appeler l'outil. C'est cette capacite de decision qui distingue un agent d'un simple chatbot.

**La localite** : Le fait de faire tourner l'IA sur le port 11434 (Ollama) garantit que les donnees marketing restent privees. Aucune donnee n'est envoyee vers des serveurs exterieurs. Les URLs analysees, le contenu des pages et les strategies generees sont traites integralement sur la machine de l'utilisateur.

**L'orchestration** : n8n sert de pont entre l'interface utilisateur et le modele de langage. Il gere le cycle complet : reception de la requete, transmission au LLM, execution des outils appeles par l'agent, reinjection des resultats, et retour de la reponse finale a l'utilisateur.

**La sécurité (Nouveau !)** : L'utilisation d'un agent autonome demande quelques précautions pour éviter des actions non désirées. Limitez toujours l'accès de l'agent en lui fournissant des outils précis (principe du moindre privilège), privilégiez la lecture seule pour les accès sensibles, et incorporez une étape de validation humaine ("Human in the Loop") pour les actions critiques. 👉 [Voir le guide de Sécurité des Agents](01-Theorie/Securite-des-agents.md)

---

## Architecture technique

### Vue d'ensemble

L'architecture repose sur trois composants principaux :

```
[Utilisateur] <-> [n8n : Orchestration] <-> [Ollama : LLM local]
                         |
                         v
                  [Outils : HTTP, Fichiers, etc.]
```

### Role de Docker (conteneurisation)

Docker permet d'isoler et de deployer n8n dans un conteneur. Les avantages sont :

- Environnement reproductible sur toutes les machines
- Isolation des dependances (aucune installation Node.js ou systeme requise)
- Gestion simplifiee des ports et du reseau

n8n s'execute dans un conteneur Docker. Pour communiquer avec Ollama installe sur la machine hote (hors conteneur), on utilise l'adresse speciale `host.docker.internal`, qui pointe vers l'hote depuis l'interieur du conteneur.

### Role de n8n (orchestration no-code)

n8n est une plateforme d'automatisation de workflows. Dans ce projet, elle sert de pont entre l'interface utilisateur et le modele de langage :

- L'utilisateur envoie une requete via un formulaire ou un trigger
- n8n transmet la requete au noeud "AI Agent"
- Le noeud AI Agent appelle l'API Ollama et gere la boucle agentique (choix d'outils, appels, synthese)
- n8n retourne la reponse finale

L'orchestration designe le fait de coordonner les appels au LLM et aux outils (HTTP Request pour fetcher une URL, par exemple) selon les instructions du prompt systeme.

### Role d'Ollama (moteur LLM local)

Ollama est un serveur local qui heberge et execute des modeles de langage (Llama, Mistral, TinyLlama, etc.) sur la machine de l'utilisateur. Il expose une API compatible OpenAI sur le port 11434. Ce projet utilise par defaut **TinyLlama**, un modele leger (environ 638 Mo) adapte aux machines modestes et au developpement.

Avantages pour le projet :

- **Localite** : Les donnees marketing analysees restent sur la machine. Aucune donnee n'est envoyee vers des serveurs exterieurs. Le fait de faire tourner l'IA sur le port 11434 (Ollama) garantit que les donnees restent privees.
- **Gratuite** : Pas d'abonnement ni de facturation a l'usage
- **Performances** : Execution sur le materiel local (CPU/GPU)

---

## Guide d'installation

### Prérequis

- Windows 10/11, macOS ou Linux
- Au moins 8 Go de RAM (16 Go recommande)
- 10 Go d'espace disque pour les modeles

### Etape 1 : Installer Docker Desktop

1. Telecharger Docker Desktop depuis [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Installer et demarrer Docker Desktop
3. Verifier l'installation en ouvrant un terminal et en executant : `docker --version`

### Etape 2 : Installer Ollama

1. Telecharger Ollama depuis [https://ollama.com](https://ollama.com)
2. Installer et lancer Ollama (il demarre automatiquement en arriere-plan)
3. Ouvrir un terminal et executer :
   - `ollama pull tinyllama` (recommandé : modele leger, environ 638 Mo)
   - ou `ollama pull llama3` (ou `ollama pull mistral`) pour des performances superieures
4. Verifier que le serveur repond : ouvrir un navigateur sur `http://localhost:11434` et verifier la presence d'Ollama

### Etape 3 : Lancer n8n avec Docker

1. Placer le fichier `docker-compose.yml` du dossier `02-Configuration` dans un repertoire de travail
2. Ouvrir un terminal dans ce repertoire et executer : `docker-compose up -d`
3. Acceder a n8n via `http://localhost:5678`
4. Creer un compte utilisateur a la premiere connexion (donnees stockees localement)

### Etape 4 : Installer le modele Ollama (TinyLlama recommande)

Ce projet utilise **TinyLlama**, un modele compact qui fonctionne sur des machines modestes. Pour l'installer :

```
ollama pull tinyllama
```

Alternatives (plus de ressources requises) :

```
ollama pull llama3
```

ou

```
ollama pull mistral
```

---

## Configuration de l'agent dans n8n

### Lier le noeud AI Agent a Ollama

1. Dans n8n, creer un nouveau workflow
2. Ajouter un noeud **AI Agent** (categorie "AI")
3. Dans la configuration du noeud :
   - **Model** : selectionner "Custom" ou configurer une connexion personnalisee
   - **Base URL** : `http://host.docker.internal:11434/v1`
   - **Model Name** : `tinyllama` (recommandé), `llama3` ou `mistral` (selon le modele installe)
   - **API Key** : laisser vide (Ollama n'en requiert pas en local)

4. Ajouter les outils necessaires (ex. HTTP Request pour fetcher une URL) et les connecter au noeud AI Agent
5. Configurer le prompt systeme pour le cas d'usage marketing (voir dossier `03-Workflows`)

### Remarque sur host.docker.internal

Sur Windows et macOS, `host.docker.internal` est automatiquement reseolu vers la machine hote. Sur Linux, il peut etre necessaire d'ajouter `extra_hosts: - "host.docker.internal:host-gateway"` dans le fichier `docker-compose.yml`.

---

## Comment creer l'agent de zéro (tutoriel pas à pas)

Pour les personnes débutantes qui n'ont jamais créé d'Agent IA sur n8n, voici un guide étape par étape pour construire vous-même votre premier agent, sans utiliser l'importation.

### Étape 1 : Préparer le terrain
1. Assurez-vous que Docker est lancé.
2. Démarrez n8n (depuis le dossier `02-Configuration`, lancez `docker-compose up -d`).
3. Vérifiez qu'Ollama toure bien avec votre modèle (`ollama pull tinyllama`).

### Étape 2 : Créer un workflow vierge et le déclencheur
1. Ouvrez `http://localhost:5678` et créez un **Nouveau Workflow**.
2. Cliquez sur **Add first step**.
3. Recherchez **"On chat message"** et sélectionnez-le. C'est votre interface de discussion.
4. N'y touchez plus pour l'instant. Laissez la boîte de dialogue ouverte.

### Étape 3 : Ajouter le Cerveau (L'Agent)
1. Cliquez sur le **+** à côté du déclencheur "On chat message".
2. Recherchez **"AI Agent"** et ajoutez-le.
3. Le noeud "AI Agent" a 3 entrées principales : le Modèle (Model), la Mémoire (Memory) et les Outils (Tools).

### Étape 4 : Connecter le réseau neuronal (Ollama)
1. Côté gauche du noeud "AI Agent", cliquez sur le **+** à côté de **Model**.
2. Recherchez **"Ollama Chat Model"** et sélectionnez-le.
3. Configurez les identifiants :
   - Cliquez sur **Create New Credential**.
   - URL : `http://host.docker.internal:11434`
   - Enregistrez.
4. Dans le champ "Model Name", écrivez le nom de votre modèle exact : `tinyllama`.

### Étape 5 : Donner une mémoire à l'agent
1. Côté gauche du nœud "AI Agent", cliquez sur le **+** de la section **Memory**.
2. Choisissez **"Window Buffer Memory"**.
3. Cela permettra à l'agent de se souvenir des messages précédents dans la discussion courante.

### Étape 6 : Donner des bras à l'agent (Les Outils)
L'agent ne peut rien faire sans outils.
1. Côté gauche du nœud "AI Agent", cliquez sur le **+** sous **Tools**.
2. Recherchez **"Wikipedia"** (c'est le plus simple pour commencer).
3. Cliquez dessus. Il est maintenant connecté à l'agent.
4. Vous pouvez en ajouter d'autres (comme **"Calculator"** pour faire des mathématiques).

### Étape 7 : Paramétrer le rôle (Le Prompt)
1. Double-cliquez sur le nœud principal **AI Agent**.
2. En bas de la fenêtre, trouvez la section **System Message**.
3. Entrez la personnalité de l'agent : `Tu es un assistant utile. Sers-toi de Wikipedia pour répondre aux questions.`

### Étape 8 : Tester votre création
1. En bas du grand écran canevas, cliquez sur le bouton "Chat".
2. Posez une question de test : "Qui a inventé le concept de conteneurisation en informatique ?"
3. Observez l'agent réfléchir (il devrait appeler l'outil Wikipedia, puis vous fournir une synthèse !).

---

## Importer un workflow existant (le plus rapide)

Si vous souhaitez aller plus vite, vous pouvez importer nos exemples prêts à l'emploi :

### 1. Cloner ou telecharger le depot

Recuperer les fichiers du depot sur votre machine (clone Git ou telechargement ZIP).

### 2. Installer TinyLlama avec Ollama

1. Installer Ollama (voir Etape 2 ci-dessus)
2. Ouvrir un terminal et executer : `ollama pull tinyllama`
3. Verifier : `ollama list` doit afficher tinyllama

### 3. Lancer n8n

1. Se placer dans le dossier `02-Configuration`
2. Executer : `docker-compose up -d`
3. Ouvrir `http://localhost:5678` dans un navigateur
4. Creer un compte (premiere connexion)

### 4. Importer le workflow

1. Dans n8n, menu **Workflow** > **Import from File**
2. Selectionner le fichier `03-Workflows/agent-marketing-exemple.json` (ou l'exemple Odoo).
3. Le workflow s'affiche sur le canevas

### 5. Configurer les identifiants Ollama

1. Menu **Parametres** (roue dentee) > **Credentials** > **Add Credential**
2. Choisir **Ollama (API)**
3. URL de base : `http://host.docker.internal:11434`
4. Nommer (ex. "Ollama local") et enregistrer
5. Ouvrir le noeud **Ollama Chat Model** dans le workflow
6. Selectionner les identifiants crees et verifiez que le nom du modele (`tinyllama`) est ecrit.

### 6. Activer et tester

1. Cliquer sur **Save** puis activez l'interrupteur en haut a droite.
2. Cliquer sur **Chat** en bas de l'ecran
3. Tester avec : "Analyse le site https://example.com et propose une strategie de contenu marketing"

---

## Structure des dossiers

```
Agent-IA-Marketing-Local-M1/
├── README.md
├── 01-Theorie/
│   ├── RAG-et-memoire.md
│   └── Memoire-des-agents.md
├── 02-Configuration/
│   └── docker-compose.yml
├── 03-Workflows/
│   ├── README.md
│   ├── README-odoo.md
│   ├── agent-marketing-exemple.json
│   └── agent-odoo-exemple.json
└── 04-Livrable/
    └── consignes-rapport.md
```

---

## Cas d'usage : Marketing

L'agent doit etre capable d'analyser une URL web et de generer une strategie de contenu marketing coherente. Fonctionnalites attendues :

- Recuperation du contenu d'une page web via un outil HTTP
- Analyse du contenu (secteur, cible, ton, axes de differenciation)
- Generation d'une strategie de contenu (objectifs, themes, formats, planning type)

Le prompt systeme et le workflow exemple sont fournis dans le dossier `03-Workflows`.

---

## Extension : Compétences Odoo (Nouveau !)

Le projet inclut désormais un exemple d'intégration de compétences (skills) permettant à l'agent d'interagir avec l'ERP Odoo.
L'agent peut, par exemple, interroger le catalogue de produits de manière autonome pour répondre à des questions complexes.

👉 [Voir la documentation Odoo et l'exemple de workflow](03-Workflows/README-odoo.md)

---

## Ressources supplementaires

- Documentation n8n : [https://docs.n8n.io](https://docs.n8n.io)
- Documentation Ollama : [https://github.com/ollama/ollama](https://github.com/ollama/ollama)
- Docker Documentation : [https://docs.docker.com](https://docs.docker.com)
