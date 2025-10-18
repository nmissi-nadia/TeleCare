package org.example.projet.model;

import jakarta.persistence.*;

@Entity
@Table(name = "profils_specialistes")
public class ProfilSpecialiste {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Association directe avec le User (spécialiste)
    @OneToOne
    @JoinColumn(name = "specialiste_id", referencedColumnName = "id", nullable = false)
    private User specialiste;

    // Optionnel : informations additionnelles
    @Column(nullable = true)
    private String description;

    public ProfilSpecialiste() {}

    public ProfilSpecialiste(User specialiste) {
        this.specialiste = specialiste;
    }

    // --- Getters & Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getSpecialiste() { return specialiste; }
    public void setSpecialiste(User specialiste) { this.specialiste = specialiste; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
