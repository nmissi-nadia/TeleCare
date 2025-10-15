package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "demandes_expertise")
public class DemandeExpertise {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private String raison;

    @Column
    private String specialiteDemandee;

    @Column
    private String statut; // EN_ATTENTE, ACCEPTEE, REFUSEE

    @Column
    private LocalDateTime dateCreation;

    @Column
    private LocalDateTime dateReponse;

    @Column
    private String observations;

    @Column
    private String diagnostic;

    @OneToOne
    @JoinColumn(name = "consultation_id")
    private Consultation consultation;

    @Column
    private String raisonRefus;

    @ManyToOne
    @JoinColumn(name = "medecin_generaliste_id")
    private MedecinGeneraliste medecinGeneraliste;

    @ManyToOne
    @JoinColumn(name = "medecin_specialiste_id")
    private MedecinSpecialiste medecinSpecialiste;

    // Constructeurs
    public DemandeExpertise() {
        this.dateCreation = LocalDateTime.now();
        this.statut = "EN_ATTENTE";
    }

    // Getters et Setters
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

    public Consultation getConsultation() { return consultation; }
    public void setConsultation(Consultation consultation) { this.consultation = consultation; }

    public MedecinGeneraliste getMedecinGeneraliste() { return medecinGeneraliste; }
    public void setMedecinGeneraliste(MedecinGeneraliste medecinGeneraliste) { this.medecinGeneraliste = medecinGeneraliste; }

    public MedecinSpecialiste getMedecinSpecialiste() { return medecinSpecialiste; }
    public void setMedecinSpecialiste(MedecinSpecialiste medecinSpecialiste) { this.medecinSpecialiste = medecinSpecialiste; }

    public String getRaisonRefus() { return raisonRefus; }
    public void setRaisonRefus(String raisonRefus) { this.raisonRefus = raisonRefus; }
}