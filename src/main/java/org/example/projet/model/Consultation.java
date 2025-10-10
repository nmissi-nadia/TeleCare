package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consultations")
public class Consultation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private LocalDateTime dateConsultation;

    @Column(length = 1000)
    private String observations;

    @Column(length = 1000)
    private String diagnostic;

    @Column(length = 1000)
    private String traitement;

    @Column
    private Double cout;

    @Column
    private String statut; // EN_ATTENTE, EN_COURS, TERMINE

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "medecin_id")
    private User medecin; // Peut être MedecinGeneraliste ou MedecinSpecialiste

    @ManyToMany
    @JoinTable(
        name = "consultation_actes",
        joinColumns = @JoinColumn(name = "consultation_id"),
        inverseJoinColumns = @JoinColumn(name = "acte_id")
    )
    private List<Acte> actes = new ArrayList<>();

    @OneToOne(mappedBy = "consultation", cascade = CascadeType.ALL)
    private DemandeExpertise demandeExpertise;

    // Constructeurs
    public Consultation() {
        this.dateConsultation = LocalDateTime.now();
        this.statut = "EN_ATTENTE";
        this.cout = 0.0;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public LocalDateTime getDateConsultation() { return dateConsultation; }
    public void setDateConsultation(LocalDateTime dateConsultation) { this.dateConsultation = dateConsultation; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public String getDiagnostic() { return diagnostic; }
    public void setDiagnostic(String diagnostic) { this.diagnostic = diagnostic; }

    public String getTraitement() { return traitement; }
    public void setTraitement(String traitement) { this.traitement = traitement; }

    public Double getCout() { return cout; }
    public void setCout(Double cout) { this.cout = cout; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public User getMedecin() { return medecin; }
    public void setMedecin(User medecin) { this.medecin = medecin; }

    public List<Acte> getActes() { return actes; }
    public void setActes(List<Acte> actes) { this.actes = actes; }

    public DemandeExpertise getDemandeExpertise() { return demandeExpertise; }
    public void setDemandeExpertise(DemandeExpertise demandeExpertise) { this.demandeExpertise = demandeExpertise; }

    // Méthode utilitaire pour calculer le coût total
    public void calculerCoutTotal() {
        this.cout = actes.stream().mapToDouble(Acte::getTarif).sum();
    }

    // Méthode pour ajouter un acte
    public void ajouterActe(Acte acte) {
        this.actes.add(acte);
        calculerCoutTotal();
    }

    // Méthode pour retirer un acte
    public void retirerActe(Acte acte) {
        this.actes.remove(acte);
        calculerCoutTotal();
    }
}
