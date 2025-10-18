package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "creneaux_specialistes")
public class CreneauSpecialiste {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Lien direct vers User (spécialiste)
    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private User specialiste;

    @Column(nullable = false)
    private LocalDate dateDisponibilite;

    @Column(nullable = false)
    private LocalTime heureDebut;

    @Column(nullable = false)
    private LocalTime heureFin;

    @Column(nullable = false)
    private Double tarif;

    @Column(nullable = false)
    private boolean disponible = true;

    public CreneauSpecialiste() {}

    public CreneauSpecialiste(User specialiste, LocalDate date, LocalTime debut, LocalTime fin, Double tarif) {
        this.specialiste = specialiste;
        this.dateDisponibilite = date;
        this.heureDebut = debut;
        this.heureFin = fin;
        this.tarif = tarif;
    }

    // --- Getters & Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getSpecialiste() { return specialiste; }
    public void setSpecialiste(User specialiste) { this.specialiste = specialiste; }

    public LocalDate getDateDisponibilite() { return dateDisponibilite; }
    public void setDateDisponibilite(LocalDate dateDisponibilite) { this.dateDisponibilite = dateDisponibilite; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public Double getTarif() { return tarif; }
    public void setTarif(Double tarif) { this.tarif = tarif; }

    public boolean isDisponible() { return disponible; }
    public void setDisponible(boolean disponible) { this.disponible = disponible; }
}
