# **Robust and Real-Time Tracker based on Consensus-based Matching and Tracking**

*16623 Advanced Computer Vision Apps Project*

*By Yujie Fang and Zeyi Huang*

## **Video Demo Link**

Video Demo: [Click here to watch the demo video](https://youtu.be/qR5i5zhDpw8)

## **Title**

Robust and Real-Time Tracker based on Consensus-based Matching and Tracking

## **Summary**

In this project, we investigate a keypoint-based method for object tracking in a combined matching and tracking framework. It is known that for a mobile device, it is a chal- lenge to design a application to track the target object with a large of number of keypoints in real-time. The use of fast keypoint detectors and binary descriptors allows for our im- plementation to run in real-time, which is well-suited for mobile application. In order to localize the object in every frame, each keypoint casts votes for the object center. As erroneous keypoints are hard to avoid, we employ a novel consensus-based scheme is employed for outlier detection in the voting. We implement the proposed tracker algorithm using OpenCV library. For experiments, we conduct real time tracking on live camera videos in 30 fps. The results show the performance and robustness and high accuracy of the tracker in the face of various challenging conditions including pose changes, occlusions, rotation and scale problem and other critical appearance variations of the object. The deliverables of our project include a runnable iOS application, a demo video to show the experimental results of our application and a final write up to explain and analyze our project.

## **Background**

Visual tracking takes the process of locating and associating moving objects over time in consecutive video frames. When a target is identified and located in one frame of a video, it is often useful to track that object in the subsequent frames. Every frame in which the target is successfully tracked provides more information about the identity and the activity of the target. There are many practical applications of visual tracking in video processing and robotics, some of which are video compression, security and surveillance.

Given the initial state of a target object in the first frame, the goal of tracking is to predict the state of the target in the following frames of a video. However, the task can be difficult when the object is moving fast relative to the camera frame rate. The problem becomes more complicated in the situation that the tracked object changes its appearance over time.

In 2010, Georg Nebehay and Roman Pflugfelder proposed a novel keypoint-based method for long-term model-free object tracking in a combined matching and tracking framework, Consensus-based Matching and Tracking of Keypoints for Object Tracking. The experimental evaluation demonstrates that the proposed method is able to achieve state-of-the-art results and that it is especially well suited when high accuracy is desired. The authors have shown that keypoints are a powerful building block for tracking when embedded into an appropriate framework. This paper shows the details of how to utilize keypoints to do CMT tracker.

## **The Challenge**

Designing a fast and robust tracker is challenging due to various critical issues, such as changes in orientation and scale, deformations, illumination variations, and even occasional occlusions. Sometimes the common appearance issues like rotations of the object can be alleviated as the motion is not rapid between frames, and the target can still be well tracked by a tracker with short tracking time. Therefore, our goal is simple. We want to build a tracker based on existed algorithms that can overcome the difficulties and issues mentioned above, and increase the tracking rate as possible as we can.

In this project, we investigate a simple tracking strategy based on keypoint. In order to localize the object in every frame, each keypoint casts votes for the object center. As erroneous keypoints are hard to avoid, we employ a novel consensus-based scheme is employed for outlier detection in the voting. The reasons we choose this kind of tracker include (1) it can track with high accuracy, (2) it has ro- bust tracking performance, (3) it can deal with occlusions, rotation, and scale problem, (4) it can run in real time.

## **Experimental Results**

- **Rotation**

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/book1.jpg" alt="alt text" width="500">

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/book2.jpg" alt="alt text" width="500">

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/arm1.jpg" alt="alt text" width="500">

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/arm2.jpg" alt="alt text" width="500">

Above figures show the results when changing the rotation of the target objects. In the first two figures, we can see that our application can robustly detect the target book when changing the orientation of it.


We also test our application in another scenario when detecting human arms. The last two figures shows that our applica- tion can correctly detect the rotated arm with high accuracy.

- **Scale**

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/pattern1.jpg" alt="alt text" width="500">

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/pattern2.jpg" alt="alt text" width="500">

In addition, we test our application under the changes of scale and we find that our application can acurately handle this scenario. Above two figures show the result of the test. We can see that as the iPad is getting away from the target object, it can still successfully detect the target object with a smaller scale.

- **Performance**

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/150p.jpg" alt="alt text" width="500">

<img src="https://raw.githubusercontent.com/EricFang1002/RobustTracking/master/Experimental Results/210p.jpg" alt="alt text" width="500">

In addition, we analyze our application with respect to FPS under certain keypoints. As the default maximum FPS for OpenCV is 30 FPS, the result with around 30 FPS is generally with high efficiency. The first figure shows the result FPS when detecting 151 keypoints simultaneously. We can see that the FPS is around 30, which means our application is efficient under this situation. However, when the number of the detected keypoints is 210, which is shown in the second figure, the FPS decreased to 18.74. This indicates that when the number of keypoints increases, the efficiency of our application decreases acordingly.

After considering the results shown abouve, we think one of the reasons that cause the efficiency is that our application only uses the CPU to process each image frame, whcih is not efficient compared to GPU. A profiling of the usage of CPU is shown in the next section. As a result, furhter work woulb be taking advantage of the high efficency of GPU when processing image-based application to accelerate our application when detecting large number of keypoints.

## **Goals & Deliverables**

- Implementation of the tracker based on consensus-based matching and tracking

- A tracker that can work at least at 30 FPS

- A live video that shows how our tracker works with respect to changes of scale and rotation of the objects

- A final write up that introduces and analyze our project

## **Schedule**

- **Check Point 1**: Research different tracking methods and implement the basic framework of the video processing for our tracker

- **Check Point 2**: Implement the first part of our tracker

- **Check Point 3**: Implement the second part of our tracker

- **Check Point 4**: Do the profiling and improve our application with respect to accuracy and efficiency
