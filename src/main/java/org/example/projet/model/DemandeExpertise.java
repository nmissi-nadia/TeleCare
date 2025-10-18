package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "demandes_expertise")
public class DemandeExpertise {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String raison;

    @Column(name = "specialite_demandee", nullable = false)
    private String specialiteDemandee;

    @Column(nullable = false)
    private String statut; // EN_ATTENTE, ACCEPTEE, REFUSEE

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    @Column(name = "date_reponse")
    private LocalDateTime dateReponse;

    @Column(columnDefinition = "TEXT")
    private String observations;

    @Column(columnDefinition = "TEXT")
    private String diagnostic;

    @Column(name = "raison_refus")
    private String raisonRefus;

    @OneToOne
    @JoinColumn(name = "consultation_id")
    private Consultation consultation;

    @ManyToOne
    @JoinColumn(name = "medecin_generaliste_id")
    private MedecinGeneraliste medecinGeneraliste;

    @ManyToOne
    @JoinColumn(name = "medecin_specialiste_id")
    private MedecinSpecialiste medecinSpecialiste;

    // --- Constructeurs ---
    public DemandeExpertise() {
        this.dateCreation = LocalDateTime.now();
        this.statut = "EN_ATTENTE";
    }

    // --- Getters et Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRaison() { return raison; }
    public void setRaison(String raison) { this.raison = raison; }

    public String getSpecialiteDemandee() { return specialiteDemandee; }
    public void setSpecialiteDemandee(String specialiteDemandee) { this.specialiteDemandee = specialiteDemandee; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public LocalDateTime getDateReponse() { return dateReponse; }
    public void setDateReponse(LocalDateTime dateReponse) { this.dateReponse = dateReponse; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public String getDiagnostic() { return diagnostic; }
    public void setDiagnostic(String diagnostic) { this.diagnostic = diagnostic; }

    public String getRaisonRefus() { return raisonRefus; }
    public void setRaisonRefus(String raisonRefus) { this.raisonRefus = raisonRefus; }

    public Consultation getConsultation() { return consultation; }
    public void setConsultation(Consultation consultation) { this.consultation = consultation; }

    public MedecinGeneraliste getMedecinGeneraliste() { return medecinGeneraliste; }
    public void setMedecinGeneraliste(MedecinGeneraliste medecinGeneraliste) { this.medecinGeneraliste = medecinGeneraliste; }

    public MedecinSpecialiste getMedecinSpecialiste() { return medecinSpecialiste; }
    public void setMedecinSpecialiste(MedecinSpecialiste medecinSpecialiste) { this.medecinSpecialiste = medecinSpecialiste; }

    // --- Méthodes utilitaires ---
    @Override
    public String toString() {
        return "DemandeExpertise{" +
                "id=" + id +
                ", specialiteDemandee='" + specialiteDemandee + '\'' +
                ", statut='" + statut + '\'' +
                ", medecinGeneraliste=" + (medecinGeneraliste != null ? medecinGeneraliste.getNom() : "null") +
                ", medecinSpecialiste=" + (medecinSpecialiste != null ? medecinSpecialiste.getNom() : "null") +
                '}';
    }
}
