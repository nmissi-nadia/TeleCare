package org.example.projet.model;


import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("SPECIALISTE")
public class MedecinSpecialiste extends User {
     @Column(name = "specialite")
    private String specialite;

    @Column(name = "tarifexpertise") // matches your DB column name
    private Double tarifExpertise;
    public String getSpecialite(){return specialite;}
    public void setSpecialite(String s){this.specialite=s;}
    public Double getTarifExpertise(){return tarifExpertise;}
    public void setTarifExpertise(Double d){this.tarifExpertise=d;}
    public String toString(){return "MedecinSpecialiste [id=" + this.getId() + ", nom=" + this.getNom() + ", prenom=" + this.getPrenom() + ", login=" + this.getLogin() + ", motDePasse=" + this.getMotDePasse() + ", role=" + this.getRole() + ", specialite=" + specialite + ", tarifExpertise=" + tarifExpertise + "]";}
}
