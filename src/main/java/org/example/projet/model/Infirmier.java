package org.example.projet.model;


import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("INFIRMIER")
public class Infirmier extends User {
    // Méthodes spécifiques si besoin
}
