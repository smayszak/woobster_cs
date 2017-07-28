using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Woobster.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }


        [HttpPost]
        public ActionResult Index(string pre, string post)
        {
            string title = Server.MapPath(Url.Content("~/Content/Title.txt"));
            string middle = Server.MapPath(Url.Content("~/Content/Proper.txt"));
            string sur = Server.MapPath(Url.Content("~/Content/Final.txt"));

            string[] properNames = System.IO.File.ReadAllLines(middle);

            string[] titleNames = System.IO.File.ReadAllLines(title);

            string[] surnames = System.IO.File.ReadAllLines(sur);
            if (pre != null)
                ViewBag.Pretag = true;
            if (post != null)
                ViewBag.Posttag = true;

            ViewBag.Name = GetName(pre, post, titleNames, properNames, surnames);
            return View();
        }

        public string GetName(string pre, string post, string[] titleNames, string[] properNames, string[] surnames)
        {
            string name = PickAName(properNames);

            if (pre != null)
            {
                string topre = PickAName(titleNames);
                name = topre + " " + name;
            }

            if (post != null)
            {
                string topost = PickAName(surnames);
                name = name + " " + topost;
            }
            return name;
        }

        private string PickAName(string[] inputArray)
        {
            var length = inputArray.Length;
            Random random = new Random();
            int randomNumber = random.Next(0, length-1);
            return inputArray[randomNumber];

        }


        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}