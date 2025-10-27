

## 🏥 TeleCare – Plateforme de Téléexpertise Médicale

### 📘 Description du projet

**TeleCare** est une application web médicale permettant la **gestion des patients, consultations et actes techniques** au sein d’un environnement hospitalier connecté.
Elle facilite la **collaboration entre infirmiers et médecins généralistes**, avec un suivi des patients en temps réel.

---

## 🎯 Objectifs du projet

* Digitaliser le processus de prise en charge des patients.
* Permettre à l’infirmier d’enregistrer les patients et leurs signes vitaux.
* Offrir au médecin généraliste un tableau de bord pour gérer les consultations.
* Intégrer un suivi du statut des patients (**en attente, en cours, terminé**).

---

## ⚙️ Architecture du projet

### 🧩 Couches principales

| Couche                       | Rôle                                                                                                                         |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **Model (Entity)**           | Contient les classes JPA représentant les tables de la base de données (`Patient`, `Consultation`, `ActeTechnique`, `User`…) |
| **DAO (Data Access Object)** | Gère les interactions avec la base via JPA et Hibernate                                                                      |
| **Servlets (Controller)**    | Contrôlent la logique métier et redirigent vers les vues JSP                                                                 |
| **JSP (Vue)**                | Interface utilisateur avec JSTL et HTML/CSS                                                                                  |

### 📂 Structure du projet

```
telecare/
│
├── src/main/java/com/telecare/
│   ├── model/
│   │   ├── Patient.java
│   │   ├── Consultation.java
│   │   ├── ActeTechnique.java
│   │   └── User.java
│   │
│   ├── dao/
│   │   ├── PatientDAO.java
│   │   ├── ConsultationDAO.java
│   │   └── UserDAO.java
│   │
│   ├── servlet/
│   │   ├── PatientServlet.java
│   │   ├── ConsultationServlet.java
│   │   ├── LoginServlet.java
│   │   ├── RegisterServlet.java
│   │   └── AuthFilter.java
│   │
│   └── util/
│       └── JPAUtil.java
│
├── src/main/webapp/
│   ├── jsp/
│   │   ├── login.jsp
│   │   ├── register.jsp
│   │   ├── patient_list.jsp
│   │   ├── patient_form.jsp
│   │   ├── consultation.jsp
│   │   └── dashboard_medecin.jsp
│   └── WEB-INF/
│       └── web.xml
│
├── pom.xml
└── README.md
```

---

## 🧠 Conception du système

### 🔹 Diagramme conceptuel simplifié (textuel)
````mermaid
classDiagram
    class User {
        - int id
        - String nom
        - String prenom
        - String login
        - String motDePasse
        - String role
    }

    class Infirmier {
        + enregistrerPatient(Patient p)
    }

    class MedecinGeneraliste {
        - double tarifConsultation
        + creerConsultation(Patient p)
        + demanderAvisSpecialiste()
        + cloturerConsultation()
    }

    class MedecinSpecialiste {
        - String specialite
        - double tarifExpertise
        + repondreDemandeExpertise()
        + voirCreneauxDisponibles()
    }

    class Patient {
        - int id
        - String nom
        - String prenom
        - LocalDate dateNaissance
        - String numSecuriteSociale
        - double tension
        - int frequenceCardiaque
        - double temperature
        - int frequenceRespiratoire
        - LocalDateTime heureArrivee
        - String statut
    }

    class Consultation {
        - int id
        - LocalDate dateConsultation
        - String observations
        - String diagnostic
        - String traitement
        - double cout
        - String statut
    }

    class ActeTechnique {
        - int id
        - String nom
        - double cout
    }

    class DemandeExpertise {
        - int id
        - LocalDate dateDemande
        - String question
        - String priorite
        - String statut
    }

    

    %% Relations
    User <|-- Infirmier
    User <|-- MedecinGeneraliste
    User <|-- MedecinSpecialiste

    Infirmier "1" --> "0..*" Patient : enregistre >
    MedecinGeneraliste "1" --> "0..*" Consultation : effectue >
    Patient "1" --> "0..*" Consultation : concerne >
    Consultation "0..1" --> "1" DemandeExpertise : peut_demander >
    DemandeExpertise "1" --> "1" MedecinSpecialiste : attribuée_à >
    Consultation "1" --> "0..*" ActeTechnique : comprend >

````
---

## 👩‍⚕️ Modules Fonctionnels

### 🧾 **Module Infirmier**

* Enregistrer un patient avec ses informations et signes vitaux.
* Consulter la liste des patients du jour.
* Voir les statuts des patients en temps réel.

### ⚕️ **Module Médecin Généraliste**

* Voir les patients en attente.
* Créer une consultation pour un patient.
* Ajouter un diagnostic et des actes techniques.
* Terminer une consultation.

### 🔁 **Scénario A – Prise en charge complète**

1. L’infirmier enregistre un patient.
2. Le patient apparaît dans la liste des "patients en attente".
3. Le médecin consulte le tableau de bord et ouvre une consultation.
4. Il saisit ses observations, diagnostics et actes techniques.
5. La consultation est terminée, le statut du patient passe à **TERMINE**.

---

## 🧱 Base de données

**SGBD : PostgreSQL**

### Exemple de configuration `persistence.xml`

```xml
<persistence-unit name="telePU" transaction-type="RESOURCE_LOCAL">
    <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
    <class>com.telecare.model.Patient</class>
    <class>com.telecare.model.Consultation</class>
    <class>com.telecare.model.ActeTechnique</class>
    <class>com.telecare.model.User</class>

    <properties>
        <property name="jakarta.persistence.jdbc.url" value="jdbc:postgresql://localhost:5432/telecare"/>
        <property name="jakarta.persistence.jdbc.user" value="postgres"/>
        <property name="jakarta.persistence.jdbc.password" value="ycode"/>
        <property name="jakarta.persistence.jdbc.driver" value="org.postgresql.Driver"/>

        <property name="hibernate.dialect" value="org.hibernate.dialect.PostgreSQLDialect"/>
        <property name="hibernate.hbm2ddl.auto" value="update"/>
        <property name="hibernate.show_sql" value="true"/>
    </properties>
</persistence-unit>
```

---

## 🚀 Installation & Exécution

### ✅ Prérequis

* **Java 17+**
* **Apache Maven 3.8+**
* **Apache Tomcat 10+**
* **PostgreSQL** installé et base `TeleCare` créée :

  ```sql
  CREATE DATABASE telecare;
  ```

### ⚙️ Étapes d’installation

1. **Cloner le projet**

   ```bash
   git clone [https://github.com/nmissi-nadia/Telecare.git](https://github.com/nmissi-nadia/TeleCare.git).git
   cd telecare
   ```

2. **Nettoyer et compiler le projet**

   ```bash
   mvn clean install
   ```

3. **Générer le fichier WAR**

   ```bash
   mvn package
   ```

4. **Déployer dans Tomcat**

   * Copier `target/telecare.war` dans `tomcat/webapps/`
   * Démarrer le serveur :

     ```bash
     ./catalina.sh run
     ```

5. **Accéder à l’application**
   👉 [http://localhost:8081/telecare](http://localhost:8081/telecare)

---

## 🧑‍💻 Technologies utilisées

| Catégorie       | Technologies                         |
| --------------- | ------------------------------------ |
| Langage         | Java 17                              |
| Framework Web   | Jakarta EE (Servlets + JSP + JSTL)   |
| ORM             | Hibernate / JPA                      |
| Base de données | PostgreSQL                           |
| Serveur         | Apache Tomcat 10                     |
| Build Tool      | Maven                                |
| Front-end       | HTML5, CSS3, JSTL, Bootstrap minimal |

---

## 💡 Pistes d’amélioration

* Gestion des rôles avec **Spring Security**.
* Ajout d’un **système de notifications temps réel** (WebSocket).
* Ajout d’un module **Admin** pour la gestion des utilisateurs.
* Intégration d’un tableau de bord statistique.

---

## 👨‍🔧 Auteurs

**Projet réalisé par :**
**🧑‍💻 NMISSI NADIA**
Encadré par **YouCode**


