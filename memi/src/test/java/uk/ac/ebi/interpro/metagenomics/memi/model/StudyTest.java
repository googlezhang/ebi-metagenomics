package uk.ac.ebi.interpro.metagenomics.memi.model;

import junit.framework.TestCase;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Test class for {@link uk.ac.ebi.interpro.metagenomics.memi.model.Study}.
 *
 * @author Maxim Scheremetjew, EMBL-EBI, InterPro
 * @version $Id$
 * @since 1.0-SNAPSHOT
 */
public class StudyTest extends TestCase {

    private Study study;

    @Before
    public void setUp() throws Exception {
        study = new Study();
    }

    @Test
    public void testInitialization() {
        assertEquals(false, study.isPublic());
        assertNotNull(study.getDate());
        assertNotNull(study.getSamples());
        assertNull(study.getStudyName());
    }

    /**
     * Tests not all but the most important setter and getter methods.
     */
    @Test
    public void testSetterAndGetter() {
        Date date = new Date();
        study.setDate(date);
        assertEquals(date, study.getDate());
        assertFalse(study.isPublic());
        study.setPublic(true);
        assertTrue(study.isPublic());
        assertEquals(0, study.getSamples().size());
        List<Sample> samples = new ArrayList<Sample>();
        samples.add(new Sample());
        study.setSamples(samples);
        assertEquals(1, study.getSamples().size());
        study.setStudyId(11);
        assertEquals(11, study.getStudyId());
        study.setStudyName("test");
        assertTrue(study.getStudyName().equals("test"));
    }

    @Test
    public void testEquals() throws Exception {
        Date date = new Date();
        Study s1 = new Study();
        s1.setStudyId(2);
        s1.setStudyName("test");
        s1.setDate(date);
        s1.setPublic(true);

        Study s2 = new Study();
        s2.setStudyId(2);
        s2.setStudyName("test");
        s2.setDate(date);
        s2.setPublic(true);

        Study s3 = new Study();
        s2.setStudyId(2);

        assertEquals(s1.getStudyId(), s2.getStudyId());
        assertEquals(s1.getStudyName(), s2.getStudyName());
        assertEquals(s1.getDate(), s2.getDate());
        assertEquals(s1.isPublic(), s2.isPublic());
        assertEquals(s1.getSamples().size(), s2.getSamples().size());

        assertNotSame(s1.getStudyId(), s3.getStudyId());

        assertTrue(s1.equals(s2));
        assertTrue(s2.equals(s1));
        assertFalse(s1.equals(s3));
        assertFalse(s2.equals(s3));
    }
}