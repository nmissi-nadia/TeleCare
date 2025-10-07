package org.example.projet.model;


import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("SPECIALISTE")
public class MedecinSpecialiste extends User {
    private String specialite;
    private Double tarifExpertise;
    public String getSpecialite(){return specialite;}
    public void setSpecialite(String s){this.specialite=s;}
    public Double getTarifExpertise(){return tarifExpertise;}
    public void setTarifExpertise(Double d){this.tarifExpertise=d;}
}
