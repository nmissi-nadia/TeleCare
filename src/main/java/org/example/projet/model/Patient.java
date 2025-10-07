package org.example.projet.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "patients")
public class Patient {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nom;
    private String prenom;
    private LocalDate dateNaissance;
    private String numSecuriteSociale;
    private Double tension;
    private Integer frequenceCardiaque;
    private Double temperature;
    private Integer frequenceRespiratoire;
    private LocalDateTime heureArrivee;
    private String statut;
    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<Consultation> consultations = new ArrayList<>();
    // Getters & Setters
    public Long getId(){return id;}
    public void setId(Long id){this.id=id;}
    public String getNom(){return nom;}
    public void setNom(String nom){this.nom=nom;}
    public String getPrenom(){return prenom;}
    public void setPrenom(String prenom){this.prenom=prenom;}
    public LocalDate getDateNaissance(){return dateNaissance;}
    public void setDateNaissance(LocalDate d){this.dateNaissance=d;}
    public String getNumSecuriteSociale(){return numSecuriteSociale;}
    public void setNumSecuriteSociale(String s){this.numSecuriteSociale=s;}
    public Double getTension(){return tension;}
    public void setTension(Double t){this.tension=t;}
    public Integer getFrequenceCardiaque(){return frequenceCardiaque;}
    public void setFrequenceCardiaque(Integer f){this.frequenceCardiaque=f;}
    public Double getTemperature(){return temperature;}
    public void setTemperature(Double temp){this.temperature=temp;}
    public Integer getFrequenceRespiratoire(){return frequenceRespiratoire;}
    public void setFrequenceRespiratoire(Integer r){this.frequenceRespiratoire=r;}
    public LocalDateTime getHeureArrivee(){return heureArrivee;}
    public void setHeureArrivee(LocalDateTime h){this.heureArrivee=h;}
    public String getStatut(){return statut;}
    public void setStatut(String statut){this.statut=statut;}
    public List<Consultation> getConsultations(){return consultations;}
    public void setConsultations(List<Consultation> c){this.consultations=c;}
}
