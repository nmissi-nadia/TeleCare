package org.example.projet.model;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("GENERALISTE")
public class MedecinGeneraliste extends User {
    private Double tarifConsultation = 150.0;
    public Double getTarifConsultation(){return tarifConsultation;}
    public void setTarifConsultation(Double t){this.tarifConsultation=t;}
}
