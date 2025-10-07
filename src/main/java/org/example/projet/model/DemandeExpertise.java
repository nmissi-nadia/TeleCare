package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "demandes_expertise")
public class DemandeExpertise {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime dateDemande;
    private String question;
    private String priorite;
    private String statut;
    @OneToOne
    @JoinColumn(name = "consultation_id")
    private Consultation consultation;
    @ManyToOne
    @JoinColumn(name = "specialiste_id")
    private MedecinSpecialiste specialiste;
    // getters/setters
    public Long getId(){return id;}
    public void setId(Long id){this.id=id;}
    public LocalDateTime getDateDemande(){return dateDemande;}
    public void setDateDemande(LocalDateTime d){this.dateDemande=d;}
    public String getQuestion(){return question;}
    public void setQuestion(String q){this.question=q;}
    public String getPriorite(){return priorite;}
    public void setPriorite(String p){this.priorite=p;}
    public String getStatut(){return statut;}
    public void setStatut(String s){this.statut=s;}
    public Consultation getConsultation(){return consultation;}
    public void setConsultation(Consultation c){this.consultation=c;}
    //public MedecinSpecialiste getSpecialiste(){return specialiste;}
    //public void setSpecialiste(MedecinSpecialiste m){this.specialiste=m;}
}
