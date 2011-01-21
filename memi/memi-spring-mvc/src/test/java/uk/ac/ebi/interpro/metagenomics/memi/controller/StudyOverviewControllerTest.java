package uk.ac.ebi.interpro.metagenomics.memi.controller;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.ui.ModelMap;
import uk.ac.ebi.interpro.metagenomics.memi.basic.SampleDAOTestImpl;
import uk.ac.ebi.interpro.metagenomics.memi.basic.StudyDAOTestImpl;
import uk.ac.ebi.interpro.metagenomics.memi.dao.EmgSampleDAO;
import uk.ac.ebi.interpro.metagenomics.memi.dao.EmgStudyDAO;
import uk.ac.ebi.interpro.metagenomics.memi.model.EmgStudy;

import java.lang.reflect.Field;

import static org.junit.Assert.*;

/**
 * Represents a test for the {@link uk.ac.ebi.interpro.metagenomics.memi.controller.StudyOverviewController}
 *
 * @author Maxim Scheremetjew, EMBL-EBI, InterPro
 * @version $Id$
 * @since 1.0-SNAPSHOT
 */
@RunWith(SpringJUnit4ClassRunner.class)
@TestExecutionListeners
public class StudyOverviewControllerTest {
    private StudyOverviewController controller;

    @Before
    public void setUp() throws Exception {
        controller = new StudyOverviewController();

        //Replace study DAO for simpler testing
        Field studyDaoField = StudyOverviewController.class.
                getDeclaredField("emgStudyDAO");
        studyDaoField.setAccessible(true);
        EmgStudyDAO newStudyDAO = new StudyDAOTestImpl();
        studyDaoField.set(controller, newStudyDAO);

        //Replace sample DAO for simpler testing
        Field sampleDaoField = StudyOverviewController.class.
                getDeclaredField("emgSampleDAO");
        sampleDaoField.setAccessible(true);
        EmgSampleDAO newSampleDAO = new SampleDAOTestImpl();
        sampleDaoField.set(controller, newSampleDAO);
    }

    @Test
    @Ignore
    public void testInitPage() throws Exception {
        ModelMap model = new ModelMap();
//        TODO: Refactor
        assertEquals("studyOverview", controller.doGetStudy("", model));
        //check model
        assertEquals(1, model.size());
        assertTrue(model.containsKey("study"));
        assertFalse(model.containsKey("test"));
        EmgStudy study = (EmgStudy) model.get("study");
        assertNotNull(study);
    }

    @Test
    @Ignore
    public void testPopulateSampleList() throws Exception {
//        List<EmgSample> result = controller.populateSampleList();
//        assertNotNull(result);
//        assertEquals(10, result.size());
//        assertEquals("sample_1", result.get(0).getSampleTitle());
//        Map<String, Object> propMap = result.get(0).getPropertyMap();
//        assertNotNull(propMap);
//        assertTrue(propMap.size() > 0);
//        String value = (String) propMap.get("geo_area");
//        assertEquals("Hinxton", value);
    }

    @Test
    @Ignore
    public void testPopulateSamplePropertyList() throws Exception {
//        List<String> result = controller.populateSamplePropertyList();
//        assertNotNull(result);
//        assertTrue(result.size() > 0);
//        assertTrue(result.contains("geo_area"));
//        assertTrue(result.contains("biome"));
//        assertFalse(result.contains("test"));
    }
}