package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consultations")
public class Consultation {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime dateConsultation;
    private String observations;
    private String diagnostic;
    private String traitement;
    private Double cout;
    private String statut;
    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;
    @ManyToOne
    @JoinColumn(name = "medecin_id")
    private MedecinGeneraliste medecin;
    @ManyToMany
    @JoinTable(name = "consultation_acte",
            joinColumns = @JoinColumn(name = "consultation_id"),
            inverseJoinColumns = @JoinColumn(name = "acte_id"))
    private List<ActeTechnique> actes = new ArrayList<>();
    @OneToOne(mappedBy = "consultation", cascade = CascadeType.ALL)
    private DemandeExpertise demandeExpertise;
    // getters/setters
    public Long getId(){return id;}
    public void setId(Long id){this.id=id;}
    public LocalDateTime getDateConsultation(){return dateConsultation;}
    public void setDateConsultation(LocalDateTime d){this.dateConsultation=d;}
    public String getObservations(){return observations;}
    public void setObservations(String s){this.observations=s;}
    public String getDiagnostic(){return diagnostic;}
    public void setDiagnostic(String s){this.diagnostic=s;}
    public String getTraitement(){return traitement;}
    public void setTraitement(String t){this.traitement=t;}
    public Double getCout(){return cout;}
    public void setCout(Double c){this.cout=c;}
    public String getStatut(){return statut;}
    public void setStatut(String s){this.statut=s;}
    public Patient getPatient(){return patient;}
    public void setPatient(Patient p){this.patient=p;}
    public MedecinGeneraliste getMedecin(){return medecin;}
    public void setMedecin(MedecinGeneraliste m){this.medecin=m;}
    public List<ActeTechnique> getActes(){return actes;}
    public void setActes(List<ActeTechnique> a){this.actes=a;}
    public DemandeExpertise getDemandeExpertise(){return demandeExpertise;}
    public void setDemandeExpertise(DemandeExpertise d){this.demandeExpertise=d;}
}
