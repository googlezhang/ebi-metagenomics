package uk.ac.ebi.interpro.metagenomics.memi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import uk.ac.ebi.interpro.metagenomics.memi.dao.EmgSampleDAO;
import uk.ac.ebi.interpro.metagenomics.memi.dao.EmgStudyDAO;
import uk.ac.ebi.interpro.metagenomics.memi.model.EmgSample;
import uk.ac.ebi.interpro.metagenomics.memi.model.EmgStudy;

import javax.annotation.Resource;
import java.util.Map;
import java.util.Set;

/**
 * Represents the controller for the study overview page.
 *
 * @author Maxim Scheremetjew, EMBL-EBI, InterPro
 * @version $Id$
 * @since 1.0-SNAPSHOT
 */
@Controller
@RequestMapping("/studyOverview")
public class StudyOverviewController {

    @Resource
    private EmgStudyDAO emgStudyDAO;

    @Resource
    private EmgSampleDAO emgSampleDAO;


    @RequestMapping(value = "/{studyId}", method = RequestMethod.GET)
    public String findStudy(@PathVariable String studyId, ModelMap model) {
        EmgStudy study = emgStudyDAO.read(studyId);
        Set<EmgSample> samples = study.getSamples();
        //Add study to model
        model.put("study", study);
        Map<String, Object> studyPropMap = study.getProperties();
        model.put("studyPropertyMap", studyPropMap);
        return "studyOverview";
    }

//    @ModelAttribute("sampleList")
//    public List<EmgSample> populateSampleList() {
//        List<EmgSample> samples = sampleDAO.retrieveAll();
//        if (samples == null) {
//            samples = new ArrayList<EmgSample>();
//        }
//        return samples;
//    }
//
//    @ModelAttribute("samplePropertyList")
//    public List<String> populateSamplePropertyList() {
//        EmgSample sample = new EmgSample();
//        List<String> result = new ArrayList<String>();
////        TODO: Refactor
////        for (String key : sample.getPropertyMap().keySet()) {
////            result.add(key);
////        }
//        return result;
//    }
}