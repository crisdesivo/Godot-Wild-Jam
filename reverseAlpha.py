"""
Python script that inverts transparency from a PNG image.
For example a pixel with alpha value of x will become a pixel with alpha value of 255 - x.
"""

import sys
import os
import cv2
import numpy as np


def invert_alpha(img):
    """
    Inverts the alpha channel of an image.
    """
    # img = img[:, :, :3]
    img[:, :, 3] = 255 - img[:, :, 3]
    return img


def main():
    file = "Assets/spot.png"
    if len(sys.argv) > 1:
        file = sys.argv[1]
    if not os.path.isfile(file):
        print("File not found:", file)
        sys.exit(1)
    img = cv2.imread(file, cv2.IMREAD_UNCHANGED)
    img[:, :, :3] = 255
    print(img.shape)
    img = invert_alpha(img)
    cv2.imwrite("Assets/inverted_spot.png", img)
    print("Done!")


if __name__ == "__main__":
    main()