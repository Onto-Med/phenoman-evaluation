import java.io.FileNotFoundException;
import org.fhir.ucum.UcumException;
import org.hl7.fhir.r4.model.Enumerations.AdministrativeGender;
import org.smith.phenoman.exception.WrongPhenotypeTypeException;
import org.smith.phenoman.io.fhir.FHIRClient;
import org.smith.phenoman.io.fhir.FHIRMan;
import org.smith.phenoman.io.fhir.code.AgeCode;
import org.smith.phenoman.io.fhir.code.GenderCode;
import org.smith.phenoman.io.fhir.code.GenderValueCode;
import org.smith.phenoman.io.fhir.search.eligibility_criteria.PatientFinder;
import org.smith.phenoman.man.PhenotypeManager;
import org.smith.phenoman.model.code_system.CodeSystem;
import org.smith.phenoman.model.phenotype.AbstractSingleDecimalPhenotype;
import org.smith.phenoman.model.phenotype.AbstractSingleStringPhenotype;
import org.smith.phenoman.model.phenotype.RestrictedSinglePhenotype;
import org.smith.phenoman.model.phenotype.enums.EligibilityCriterion;
import org.smith.phenoman.model.phenotype.enums.TimeEntity;
import org.smith.phenoman.model.phenotype.top_level.Category;
import org.smith.phenoman.model.resource_type.RTCondition;
import org.smith.phenoman.model.resource_type.RTObservationComponent;
import org.smith.phenoman.model.resource_type.RTPatientAge;
import org.smith.phenoman.model.resource_type.RTPatientGender;

import de.imise.onto_api.entities.restrictions.data_range.DecimalRangeLimited;
import de.imise.onto_api.entities.restrictions.data_range.StringRange;

public class MIBE {

	public static void main(String[] args) throws WrongPhenotypeTypeException, FileNotFoundException, ClassNotFoundException, UcumException {
		PhenotypeManager man = new PhenotypeManager("MIBE.owl", true);
		
		man.addCategory(new Category("MIBE"));
		
		AbstractSingleDecimalPhenotype ageIC = new AbstractSingleDecimalPhenotype("Age_IC", "Age Inclusion Criterion", "MIBE");
		ageIC.setResourceType(RTPatientAge.class);
		ageIC.setEligibilityCriterion(EligibilityCriterion.INCLUSION);
		ageIC.addUnit(AgeCode.UNIT);
		ageIC.addCode(new AgeCode());
		man.addAbstractSinglePhenotype(ageIC);
		man.addRestrictedSinglePhenotype(ageIC.createRestrictedPhenotype(new DecimalRangeLimited().setMinInclusive(40).setMaxInclusive(65)));
		
		AbstractSingleStringPhenotype genderIC = new AbstractSingleStringPhenotype("Gender_IC", "Gender Inclusion Criterion", "MIBE");
		genderIC.setResourceType(RTPatientGender.class);
		genderIC.setEligibilityCriterion(EligibilityCriterion.INCLUSION);
		genderIC.addCode(new GenderCode());
		man.addAbstractSinglePhenotype(genderIC);
		man.addRestrictedSinglePhenotype(genderIC.createRestrictedPhenotype("Gender_IC_s_Male", new StringRange(new GenderValueCode(AdministrativeGender.MALE).getCodeUri())));
		
		AbstractSingleDecimalPhenotype sbpIC = new AbstractSingleDecimalPhenotype("Systolic_Blood_Pressure_IC", "Systolic Blood Pressure Inclusion Criterion", "MIBE");
		sbpIC.setResourceType(RTObservationComponent.class);
		sbpIC.setValidityPeriod(1, TimeEntity.YEAR);
		sbpIC.setEligibilityCriterion(EligibilityCriterion.INCLUSION);
		sbpIC.addUnit("mm[Hg]");
		sbpIC.addCode(CodeSystem.LOINC, "8480-6", "Systolic blood pressure");
		man.addAbstractSinglePhenotype(sbpIC);
		man.addRestrictedSinglePhenotype(sbpIC.createRestrictedPhenotype(new DecimalRangeLimited().setMinInclusive(130)));

		AbstractSingleDecimalPhenotype infEC = new AbstractSingleDecimalPhenotype("Myocardial_Infarction_EC", "Myocardial Infarction Exclusion Criterion", "MIBE");
		infEC.setResourceType(RTCondition.class);
		infEC.setEligibilityCriterion(EligibilityCriterion.EXCLUSION);
		infEC.addCode(CodeSystem.SNOMED, "22298006", "Myocardial infarction (disorder)");
		man.addAbstractSinglePhenotype(infEC);

		AbstractSingleDecimalPhenotype strEC = new AbstractSingleDecimalPhenotype("Stroke_EC", "Stroke Exclusion Criterion", "MIBE");
		strEC.setResourceType(RTCondition.class);
		strEC.setEligibilityCriterion(EligibilityCriterion.EXCLUSION);
		strEC.addCode(CodeSystem.SNOMED, "230690007", "Cerebrovascular accident (disorder)");
		man.addAbstractSinglePhenotype(strEC);
		
		man.write();

		RestrictedSinglePhenotype ageICr = man.getRestrictedSinglePhenotype("Age_IC_s_ge_40_le_65");
		RestrictedSinglePhenotype genderICr = man.getRestrictedSinglePhenotype("Gender_IC_s_Male");
		RestrictedSinglePhenotype sbpICr = man.getRestrictedSinglePhenotype("Systolic_Blood_Pressure_IC_s_ge_130");
		
		FHIRClient c = FHIRMan.getHDSClient();
		PatientFinder f = new PatientFinder(c, true);
		
		f.inclusionCriteria(ageIC, ageICr).inclusionCriteria(genderIC, genderICr).inclusionCriteria(sbpIC, sbpICr).exclusionCriteria(infEC, strEC);
		System.out.print("number of patients:" + f.getPatientsNumber());
	}

}
