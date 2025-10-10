package org.example.projet.model;

import jakarta.persistence.*;

@Entity
@Table(name = "actes")
public class Acte {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String libelle;

    @Column(nullable = false)
    private Double tarif;

    @Column
    private String description;

    @Column
    private String categorie; // CONSULTATION, ANALYSE, RADIOLOGIE, etc.

    // Constructeurs
    public Acte() {}

    public Acte(String libelle, Double tarif, String categorie) {
        this.libelle = libelle;
        this.tarif = tarif;
        this.categorie = categorie;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Double getTarif() { return tarif; }
    public void setTarif(Double tarif) { this.tarif = tarif; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategorie() { return categorie; }
    public void setCategorie(String categorie) { this.categorie = categorie; }
}