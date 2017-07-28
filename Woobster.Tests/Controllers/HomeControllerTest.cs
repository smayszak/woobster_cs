using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Woobster;
using Woobster.Controllers;

namespace Woobster.Tests.Controllers
{
    [TestClass]
    public class HomeControllerTest
    {
        [TestMethod]
        public void Index()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            ViewResult result = controller.Index() as ViewResult;

            // Assert
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void SingleNameGenerator()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            string name = controller.GetName(null, null, new string[] { "dr" }, new string[] { "steve" }, new string[] { "mayszak" });


            // Assert
            Assert.IsNotNull(name);
            Assert.IsTrue(name.Equals("steve"));
        }


        [TestMethod]
        public void TitleGeneration()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            string name = controller.GetName("on", null, new string[] { "dr" }, new string[] { "steve" }, new string[] { "mayszak" });

            // Assert
            Assert.IsNotNull(name);
            Assert.IsTrue(name.Equals("dr steve"));
        }

        [TestMethod]
        public void SurGeneration()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            string name = controller.GetName(null, "on", new string[] { "dr" }, new string[] { "steve" }, new string[] { "mayszak" });

            // Assert
            Assert.IsNotNull(name);
            Assert.IsTrue(name.Equals("steve mayszak"));
        }


        [TestMethod]
        public void FullNameGeneration()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            string name = controller.GetName("on", "on", new string[] { "dr" }, new string[] { "steve" }, new string[] { "mayszak" });

            // Assert
            Assert.IsNotNull(name);
            Assert.IsTrue(name.Equals("dr steve mayszak"));
        }

        [TestMethod]
        public void Contact()
        {
            // Arrange
            HomeController controller = new HomeController();

            // Act
            ViewResult result = controller.Contact() as ViewResult;

            // Assert
            Assert.IsNotNull(result);
        }
    }
}
